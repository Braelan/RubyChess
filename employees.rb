class Employee
     attr_reader :salary
  def initialize(salary, name, title, boss = nil)
    @salary, @name, @title, @boss = salary, name, title, boss
    boss.add_employee(self) if boss
  end

  def bonus(multiplier)
    salary * multiplier
  end

end

class Manager < Employee

  def initialize(salary, name, title, boss= nil)
    super(salary, name,title,boss)
    @employees = []
  end

  def bonus(multiplier)
    self.sub_salaries * multiplier
  end

  def add_employee(employee)
    @employees << employee
  end

  def sub_salaries
    sal = 0
    @employees.each do |employee|

    sal +=  employee.class == Manager ?  employee.salary + employee.sub_salaries : employee.salary
    end
    sal
  end

end
