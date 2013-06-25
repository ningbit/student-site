require 'sqlite3'

class Student
  attr_accessor :id, :url, :name, :tagline, :bio
  @@db = SQLite3::Database.new("students.db")

# class methods
  def self.create_table
    @@db.execute <<-SQL
      create table students (
        id INTEGER PRIMARY KEY,
        name varchar(35),
        tagline text,
        bio text
      );
    SQL
  end

  def self.drop
    @@db.execute("DROP TABLE IF EXISTS students")
  end

  def generate_record(array)
    record = array.collect do |array|
        id = array[0]
        name = array[1]
        tagline = array[2]
        bio = array[3]
        student = Student.new(id,name,tagline,bio)
        student
    end
    if record.size == 1
      record.first
    else
      record
    end
  end

  def self.db
    table_array = @@db.execute("SELECT * FROM students")
  end

  def self.all
    table_array = @@db.execute("SELECT * FROM students")
    object_array = []
    table_array.each do |array|
      name = array[1]
      id = array[0]
      tagline = array[2]
      bio = array[3]
      s = Student.new(id,name,tagline,bio)
      object_array << s
    end
    object_array
  end

  def self.table_exists?(table_name)
    @@db.execute("SELECT * FROM sqlite_master WHERE type='table' AND name=?",table_name)
  end

  def self.exists?(id_num)
    bool = false
    table_array = @@db.execute("SELECT * FROM students")
    table_array.each do |array|
      bool = true if array[0] == id_num
    end
    bool
  end

  def self.find(id_num)
    Student.all.select {|obj| obj if obj.id == id_num}.first
  end

  def self.where(search_hash)
    object_array = []
    student_array = @@db.execute("SELECT * FROM students WHERE name=?",search_hash[:name])
    student_array.each do |array|
      name = array[1]
      id = array[0]
      student = Student.new(id,name)
      object_array << student
    end
    object_array
  end

  def self.find_by_name(name_string)
    puts "....finding #{name_string}"
    array = @@db.execute("SELECT * FROM students WHERE name=?",name_string).first
    name = array[1]
    id = array[0]
    student = Student.new(id,name)
    student
  end

  def self.find_by_tagline(string)
    puts "....finding tagline \"#{string}\""
    array = @@db.execute("SELECT * FROM students WHERE tagline=?",string).first
    name = array[1]
    id = array[0]
    tagline = array[2]
    bio = array[3]
    student = Student.new(id,name)
    student
  end

  def self.find_by_bio(string)
    puts "....finding bio \"#{string}\""
    array = @@db.execute("SELECT * FROM students WHERE bio=?",string).first
    name = array[1]
    id = array[0]
    tagline = array[2]
    bio = array[3]
    student = Student.new(id,name)
    student
  end

# instance methods
  def initialize(id=0,name="new_student",tagline="",bio="")
    @id = id
    @name = name
    @tagline = tagline
    @bio = bio
    insert_blank_student if @id == 0
  end

  def insert_blank_student
    @@db.execute("INSERT INTO students (name, tagline, bio)
           VALUES (?, ?, ?)",[@name, @tagline, @bio])
    @id = get_id_from_table
  end

  def get_id_from_table
    array = @@db.execute("SELECT * FROM students WHERE name=?","new_student").first
    array[0]
  end

  def save
    puts "...inserting #{self.name} into the db"
    @@db.execute("UPDATE students SET name=?, tagline=?, bio=? WHERE id=?",[@name,@tagline,@bio,@id])
  end
end