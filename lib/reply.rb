require_relative 'questions_database.rb'
require_relative 'data_point.rb'

class Reply < DataPoint
  def self.find_by_user_id(id)
    raw = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.user_id = ?
    SQL

    self.new(raw.first)
  end

  def self.find_by_question_id(id)
    raw = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.question_id = ?
    SQL

    self.new(raw.first)
  end

  attr_accessor :id, :author_id, :question_id, :parent_id, :body

  def initialize(options = {})
    @id = options['id']
    @author_id = options['author_id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @body = options['body']
  end

  def author
    User.find_by_id(self.author_id)
  end

  def question
    Question.find_by_id(self.question_id)
  end

  def parent_reply
    Reply.find_by_id(self.parent_id)
  end

  def child_replies
    raw = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.parent_id = ?
    SQL

    raw.map { |reply| Reply.new(reply) }
  end
end
