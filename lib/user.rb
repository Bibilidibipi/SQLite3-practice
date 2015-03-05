require_relative 'questions_database.rb'
require_relative 'data_point.rb'

class User < DataPoint
  def self.find_by_name(fname, lname)
    raw = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        users.fname = ? AND users.lname = ?
    SQL

    self.new(raw.first)
  end

  attr_accessor :id, :fname, :lname

  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def authored_questions
    Question.find_by_author_id(self.id)
  end

  def authored_replies
    Reply.find_by_user_id(self.id)
  end

  def followed_questions
    QuestionFollow.followers_for_question_id(self.id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(self.id)
  end

  def average_karma
    raw = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT
        CAST(COUNT(question_likes.id) AS FLOAT) / COUNT(DISTINCT(questions.id)) AS average_karma
      FROM
        users
      JOIN
        questions on users.id = questions.author_id
      LEFT OUTER JOIN
        question_likes on questions.id = question_likes.question_id
      WHERE
        users.id = ?
    SQL

    raw.first['average_karma']
  end
end
