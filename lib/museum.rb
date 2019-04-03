class Museum

  attr_reader :name,
              :exhibits,
              :patrons

  def initialize(name)
    @name = name
    @exhibits = []
    @patrons = []
  end

  def add_exhibit(exhibit)
    @exhibits.push(exhibit)
  end

  def recommend_exhibits(patron)
    @exhibits.select do |e|
      patron.interests.include?(e.name)
    end
  end

  def admit(patron)
    @patrons.push(patron)
  end

  def patrons_by_exhibit_interest
    hash = {}
    @exhibits.each do |e|
      hash[e] = @patrons.find_all { |p|
         p.interests.include?(e.name) }
    end
    hash
  end

  def patrons_of_exhibits
  end

  def revenue
  end

end
