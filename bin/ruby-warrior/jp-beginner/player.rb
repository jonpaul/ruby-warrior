class Player
	DIRECTIONS = [:forward, :backward, :left, :right]

	def full_health?
	  @warrior.health == 20
	end
	
	def should_seek_rest?
	  @warrior.health.to_f/20.0 < 0.5
	end
	
	def safe_to_rest?
	  !adjacent_enemy? && !taking_damage?
	end
	
	def safe_retreat?()
	  retreat_direction = ([:forward,:backward] - [@direction]).first
	  if @warrior.feel(retreat_direction).empty?
	    retreat_direction
	  end
	end
	
	def avoid_obstacles(direction)
	  @warrior.feel(direction).wall? ? ([:forward,:backward] - [direction]).first : direction
	end
	
	 def taking_damage?
 	  @warrior.health < @health
 	end
	
	def adjacent_enemy?
	  DIRECTIONS.find do |d|
	    @warrior.feel(d).enemy?
	  end
	end
	
	def adjacent_captive?
	   DIRECTIONS.find do |d|
	     @warrior.feel(d).captive?
	   end
	 end
	 
	 def shoot_wizard?
	   DIRECTIONS.find do |d|
	     @warrior.look(d).select {|s| s.empty? || s.captive?}.first || @warrior.look(d).last
	    end
	  end
	 
	 def take_action
	   if d = adjacent_enemy?
	     @warrior.attack!(d)
	   elsif d = adjacent_captive?
	     @warrior.rescue!(d)
	   elsif d = shoot_wizard?
	     @warrior.shoot!(d)
	   else
	     @direction = avoid_obstacles(@direction)
	     @warrior.walk!(@direction)
	   end
	 end
	
  def play_turn(warrior)
	@warrior = warrior
	@direction ||= :backward
	puts warrior.look
	if !full_health?
	  if safe_to_rest?
	    @warrior.rest!
	  elsif (d = safe_retreat?) && should_seek_rest?
	    @warrior.walk!(d)
	  else
	    take_action
	  end
	 else
	   take_action
	 end
	 
	 
	@health = warrior.health
  end
end
