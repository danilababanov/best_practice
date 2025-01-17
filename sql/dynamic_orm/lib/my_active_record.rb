require_relative '../config/environment.rb'
require 'active_support/inflector'

class MyActiveRecord
  def initialize(options = {})
    options.each { |k, v| self.send("#{k}=", v) }
  end

  def self.table_name
    self.to_s.downcase.pluralize
  end

  def self.column_names
    column_names = []
    DB.execute("PRAGMA table_info(#{self.table_name})").each { |e| column_names << e['name'] }
    column_names
  end

  def col_names_for_insert
    self.class.column_names.delete_if { |a| a == 'id' }.join(', ')
  end

  def values_for_insert
    values = []
    self.class.column_names.each do |col_name|
      values << "'#{send(col_name)}'" unless send(col_name).nil?
    end
    values.join(', ')
  end

  def table_name_for_insert
    self.class.table_name
  end

  def self.find_by_name(name)
    DB.execute("SELECT * FROM #{self.table_name} WHERE name = ?", name)
  end

  def save
    DB.execute("INSERT INTO #{table_name_for_insert}(#{col_names_for_insert}) 
    	        VALUES(#{values_for_insert})")

    @id = DB.execute("SELECT last_insert_rowid()
    	              FROM #{table_name_for_insert}")[0][0]
  end
end
