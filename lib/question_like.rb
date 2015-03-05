require_relative 'questions_database.rb'
require_relative 'data_point.rb'

class QuestionLike < DataPoint
  def self.likers_for_question_id(id)
    raw = QuestionDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      JOIN
        question_like ON question_like.user_id = users.id
      WHERE
        question_like.question_id = ?
    SQL

    raw.map { |user| User.new(user) }
  end

  def self.num_likes_for_question_id(id)
    raw = QuestionDatabase.instance.execute(<<-SQL, id)
      SELECT
        COUNT(*)
      FROM
        users
      JOIN
        question_like ON question_like.user_id = users.id
      WHERE
        question_like.question_id = ?
    SQL

    raw.first
  end

  def self.liked_questions_for_user_id(id)
    raw = QuestionDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      JOIN
        question_like ON question_like.question_id = questions.id
      WHERE
        question_like.user_id = ?
    SQL

    raw.map { |question| User.new(question) }
  end

  def self.most_liked_questions(n)
    raw = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        *
      FROM
        questions
      LEFT OUTER JOIN
        question_likes ON question_likes.question_id = questions.id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(*)
      LIMIT ?
    SQL

    raw.map { |question| Question.new(question) }
  end

  attr_accessor :id, :user_id, :question_id

  def initialize(options = {})
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end
