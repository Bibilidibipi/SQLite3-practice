require_relative 'user.rb'
require_relative 'question.rb'
require_relative 'reply.rb'
require_relative 'question_follow.rb'
require_relative 'question_like.rb'

if User.all.empty?
  User.new('fname' => 'John', 'lname' => 'Smith').save
  User.new('fname' => 'Jane', 'lname' => 'Smith').save
  User.new('fname' => 'Andrew', 'lname' => 'Smith').save
  User.new('fname' => 'Kim', 'lname' => 'Smith').save
  User.new('fname' => 'John', 'lname' => 'Jones').save
  User.new('fname' => 'Jane', 'lname' => 'Jones').save
  User.new('fname' => 'Andrew', 'lname' => 'Jones').save
  User.new('fname' => 'Kim', 'lname' => 'Jones').save
end

if Question.all.empty?
  Question.new('title' => 'why?', 'body' => 'why', 'author_id' => 1).save
  Question.new('title' => 'when?', 'body' => "you don't... bodies could just be anything", 'author_id' => 1).save
  Question.new('title' => 'why, again?', 'body' => "you don't want to know.", 'author_id' => 3).save
  Question.new('title' => 'why me!', 'body' => "alright", 'author_id' => 4).save
  Question.new('title' => 'why not you?', 'body' => "unhuuh", 'author_id' => 4).save
  Question.new('title' => 'WHY YOU', 'body' => "answer 5", 'author_id' => 6).save
end

if Reply.all.empty?
  Reply.new('author_id' => 1, 'question_id' => 1, 'body' => "let's see").save
  Reply.new('author_id' => 4, 'question_id' => 1, 'parent_id' => 1, 'body' => "reply").save
  Reply.new('author_id' => 6, 'question_id' => 2, 'body' => "dead on arrival").save
  Reply.new('author_id' => 2, 'question_id' => 3, 'body' => "made of water").save
  Reply.new('author_id' => 2, 'question_id' => 4, 'body' => "syntax error !!!!!!!!!!!!!!").save
  Reply.new('author_id' => 2, 'question_id' => 4, 'parent_id' => 5, 'body' => "hmm...").save
  Reply.new('author_id' => 1, 'question_id' => 5, 'body' => "the... uh...").save
  Reply.new('author_id' => 3, 'question_id' => 6, 'body' => "I'm pretty sure dictators are not supposed to do that").save
end

if QuestionFollow.all.empty?
  QuestionFollow.new('user_id' => 1, 'question_id' => 2).save
  QuestionFollow.new('user_id' => 1, 'question_id' => 5).save
  QuestionFollow.new('user_id' => 2, 'question_id' => 5).save
  QuestionFollow.new('user_id' => 3, 'question_id' => 6).save
  QuestionFollow.new('user_id' => 5, 'question_id' => 2).save
  QuestionFollow.new('user_id' => 5, 'question_id' => 4).save
end

if QuestionLike.all.empty?
  QuestionLike.new('user_id' => 1, 'question_id' => 2).save
  QuestionLike.new('user_id' => 1, 'question_id' => 6).save
  QuestionLike.new('user_id' => 2, 'question_id' => 3).save
  QuestionLike.new('user_id' => 4, 'question_id' => 2).save
  QuestionLike.new('user_id' => 4, 'question_id' => 1).save
end
