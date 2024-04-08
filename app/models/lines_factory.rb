class LinesFactory
  def self.new_instance(line, insured)
    line_class = "Lines::#{line.camelize}".constantize
    line_class.new(insured)
  end
end
