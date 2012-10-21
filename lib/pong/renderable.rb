require 'forwardable'
require 'component'

java_import org.newdawn.slick.geom.Polygon
java_import org.newdawn.slick.geom.Vector2f
java_import org.newdawn.slick.geom.Transform

class Renderable < Component
  attr_reader :image
  attr_accessor :position_x, :position_y, :scale
  attr_accessor :rotation # degrees

  extend Forwardable
  def_delegators :image, :width, :height  # Its image knows the dimensions.

  def initialize(image_fn)
    super()
    @image = Image.new(image_fn)

    @position_x = 25
    @position_y = 0
    @scale      = 1.0
    @rotation   = 0
  end

  def update(container, delta)
    input = container.get_input
    
    if input.is_key_down(Input::KEY_A)
      rotate(-0.2 * delta)
      self.rotation = image.rotation
    elsif input.is_key_down(Input::KEY_D)
      rotate(0.2 * delta)
      self.rotation = image.rotation
    end
  end

  def render(container, graphics)
    p = bounding_box
    #graphics.draw(p)
    image.draw(position_x, position_y, scale)
  end

  def rotate(amount)
    image.rotate(amount)
  end

  def bounding_box
    polygon = Polygon.new
    polygon.addPoint(position_x, position_y)
    polygon.addPoint(position_x + width, position_y)
    polygon.addPoint(position_x + width, position_y + height)
    polygon.addPoint(position_x, position_y + height)

    center = Vector2f.new(position_x + width/2.0*scale, position_y + height/2.0*scale)

    rotate_transform = Transform.createRotateTransform(rotation * Math::PI / 180.0, center.getX, center.getY)
    #scale_transform = Transform.createScaleTransform(scale, scale)

    polygon = polygon.transform(rotate_transform)
    #polygon = polygon.transform(scale_transform)

    return polygon
  end

  def intersects(other)
    return bounding_box.intersects(other.bounding_box)
  end
end
