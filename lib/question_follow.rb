require_relative 'questions_database.rb'
require_relative 'data_point.rb'

class QuestionFollow < DataPoint
  def self.followers_for_question_id(id)
    raw = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      JOIN
        question_follows ON user.id = question_follow.user_id
      WHERE
        question_follows.question_id = ?
    SQL

    raw.map { |user| User.new(user) }
  end

  def self.followed_questions_for_user_id(id)
    raw = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      JOIN
        question_follows ON questions.id = question_follow.question_id
      WHERE
        question_follows.user_id = ?
    SQL

    raw.map { |question| Question.new(question) }
  end

  def self.most_followed_questions(n)
    raw = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        *
      FROM
        questions
      LEFT OUTER JOIN
        question_follows ON question_follows.question_id = questions.id
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
