class Languages
  ALL_LANGUAGES = %w(rb cpp)
  def initialize(solve_file)
    @solve_file = solve_file
  end

  def compile(problem_name)
    raise 'Error: Not Implemented'
  end

  def execute(input_path, output_path)
    raise 'Error: Not Implemented'
  end
end

class Rb < Languages
  def compile(problem_name)
    true
  end

  def execute(input_path, output_path)
    system "ruby #{@solve_file} < #{input_path} > #{output_path}"
  end
end

class Cpp < Languages
  def compile(problem_name)
    @exec_file = "#{problem_name}.out"
    system "g++ #{@solve_file} -o #{problem_name}.out"
  end

  def execute(input_path, output_path)
    system "./#{@exec_file} < #{input_path} > #{output_path}"
  end
end