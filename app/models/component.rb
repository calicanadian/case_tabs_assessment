class Component < ApplicationRecord
  validates_uniqueness_of :name
  validates_presence_of :name, :command
  validates :name, uniqueness: {case_sensitive: false}, length: {maximum: 10}
  validates :command, length: {maximum: 80}

  has_many :relationships
  has_many :dependents, through: :relationships

  def self.parse_input(input)
    command = input.split(" ")[0]
    case command
    when "INSTALL"
      component = input.split(command)[1]
      installed_component = create_component(component, input)
      return [type: command, message: "Installing #{installed_component.name}", component: installed_component]
    when "DEPEND"
      # ['depend', 'item1', 'item2', 'component']
      # set dependencies on last index to index 1 and 2
      components = input.split(command)[1]
      items = components.split(" ")
      first_item = items.shift.strip
      puts "FIRST ITEM: '#{first_item}'"
      named_component = Component.find_by_name(first_item)
      installed_dependencies = []
      items.length.times do
        item = items.shift
        puts "ITEM: #{item}"
        puts "INPUT: #{input}"
        puts "NAMED COMPONENT: #{named_component}"
        installed_dependencies << create_dependent_component(item, input, named_component)
      end
      return [type: command, message: "Installing Dependencies on #{named_component.name}", component: installed_dependencies]
    when "REMOVE"
      # remove component
      component_name = input.split(command)[1]
      component = Component.find_by_name(component_name.strip)
      if component
        return [type: command, message: "Cannot destroy component with dependents", component: component.dependents] unless component.dependents.blank?
        relationships = Relationship.where("dependent_id = ? OR component_id = ?", component.id, component.id).all
        relatioships.destroy_all
        component.destroy
        return [type: command, message: "Removing #{component_name}", component: nil]
      else
        return [type: command, message: "Component not found", component: nil]
      end
    when "LIST"
      # list all components and dependencies
      return [type: command, message: "Listing Components", component: Component.order(:name).all]
    when "HELP"
      # list out the commands and syntax
      return [type: command, message: ["INSTALL 'component' -- Installs a new component", "DEPEND 'component', 'item' -- Sets dependency on component", "REMOVE 'component' -- Removes component", "LIST -- Lists all components", "HELP -- Displays a list of available commands", "END -- Terminates session"], component: Component.all]
    when "END"
      # end
      return [type: command, message: nil, component: nil]
    else
      return [type: nil, message: "I'm sorry Dave. I cannot allow you to do that.", component: nil]
    end
  end

  def self.create_component(name, command)
    Component.create(name: name.strip, command: command)
  end

  def self.create_dependent_component(name, command, parent)
    component = Component.find_by_name(name)
    if component
      Relationship.create(component_id: parent.id, dependent_id: component.id)
    end
  end
end
