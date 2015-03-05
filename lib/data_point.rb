require "active_support/inflector"

class DataPoint
  def self.underscore(camel_cased_word)
     camel_cased_word.to_s.gsub(/::/, '/').
       gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
       gsub(/([a-z\d])([A-Z])/,'\1_\2').
       tr("-", "_").
       downcase
  end

  def self.table_name
    underscore(self.to_s.pluralize)
  end

  def self.all
    raw = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
    SQL

    raw.map { |raw_data| self.new(raw_data) }
  end

  def self.find_by_id(id)
    raw = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{table_name}.id = ?
    SQL

    self.new(raw.first)
  end

  def column_names
    bare_names = self.instance_variables.map { |v| v.to_s[1..-1] }
    "(" + bare_names[1..-1].join(', ') + ")"
  end

  def get_vars
    self.instance_variables[1..-1].map { |v| self.instance_variable_get(v) }
  end

  def get_names
    update_values = []
    self.instance_variables.each do |v|
      update_values << (v.to_s[1..-1] + ' = ?')
    end
    update_values.join(', ')
  end

  def set_values
    '(' + ('?, ' * num_vars).chomp(', ') + ')'
  end

  def num_vars
    self.instance_variables.length - 1
  end

  def save
    if id.nil?
      create
    else
      update
    end
  end

  def create
    QuestionsDatabase.instance.execute(<<-SQL, *get_vars)
      INSERT INTO
        #{self.class.table_name} #{column_names}
      VALUES
        #{set_values}
    SQL

    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update
    QuestionsDatabase.instance.execute(<<-SQL, *get_vars, @id)
      UPDATE
        #{self.class.table_name}
      SET
        #{get_names}
      WHERE
        #{self.classtable_name}.id = ?
    SQL
  end
end
