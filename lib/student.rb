require "pry"
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    DB[:conn].execute("SELECT * FROM students").map do |row|
      self.new_from_db(row)
    end

    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    row = DB[:conn].execute("SELECT * FROM students WHERE name = ?", name)[0]
    self.new_from_db(row)

    # find the student in the database given a name
    # return a new instance of the Student class
  end

  def self.count_all_students_in_grade_9
    DB[:conn].execute("SELECT * FROM students WHERE grade = ?", 9)
  end

  def self.students_below_12th_grade
    DB[:conn].execute("SELECT * FROM students WHERE grade != ?", 12)
  end

  def self.first_X_students_in_grade_10(number_of_students)
    DB[:conn].execute("SELECT * FROM students WHERE grade = ? LIMIT ?", 10, number_of_students )
  end

  def self.first_student_in_grade_10
    row = DB[:conn].execute("SELECT * FROM students WHERE grade = ? LIMIT ?", 10, 1)[0]
    self.new_from_db(row)
  end

  def self.all_students_in_grade_X(grade)
    DB[:conn].execute("SELECT * FROM students WHERE grade = ?", grade)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
