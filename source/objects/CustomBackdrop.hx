package objects;

import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.util.FlxAxes;

/**
	A scrolling checkerboard backdrop made entirely in code (no image files).

	Example:
     var bd = new CustomBackdrop(60, 45, 0xFF8800FF, 0.6);
     add(bd);

	Direction is in degrees, using screen coordinates:
     0 = right, 90 = down, 180 = left, 270 (or -90) = up
*/

class CustomBackdrop extends FlxBackdrop
{
	/** Scroll speed in pixels per second. */
	public var speed(default, set):Float = 0;

	/** Scroll direction in degrees (0 = right, 90 = down). */
	public var direction(default, set):Float = 0;

	/**
	 * @param speed     Pixels per second. 0 = static.
	 * @param direction Degrees. 0 = right, 90 = down, 180 = left, 270 = up.
	 * @param colour    Tint of the pattern (e.g. 0xFF8800FF or FlxColor.PURPLE).
	 * @param alpha     Transparency, 0 (invisible) to 1 (solid).
	 * @param tileSize  Size of each checker square in pixels.
	 */
	public function new(speed:Float = 50, direction:Float = 45, colour:FlxColor = 0xFF303030, alpha:Float = 1, tileSize:Int = 40)
	{
		// Build a white/light-grey checker tile. The colour is applied as a tint,
		// so it can be changed or tweened later without rebuilding anything.
		var grid = FlxGridOverlay.create(tileSize, tileSize, tileSize * 2, tileSize * 2, true, 0xFFFFFFFF, 0xFFB0B0B0);
		var bitmap = grid.pixels.clone();
		grid.destroy();

		super(bitmap, FlxAxes.XY);

		this.color = colour;
		this.alpha = alpha;
		this.scrollFactor.set(0, 0);

		// Set through the private fields first, then apply velocity once.
		this.speed = speed;
		this.direction = direction;
	}

	/** Change speed and direction in one call. */
	public function setMovement(speed:Float, direction:Float):Void
	{
		this.speed = speed;
		this.direction = direction;
	}

	/** Tween the tint colour. */
	public function tweenColour(to:FlxColor, duration:Float = 1, ?ease:Float->Float):FlxTween
	{
		return FlxTween.color(this, duration, this.color, to, {ease: ease != null ? ease : FlxEase.sineInOut});
	}

	/** Tween the transparency. */
	public function tweenAlpha(to:Float, duration:Float = 1, ?ease:Float->Float):FlxTween
	{
		return FlxTween.tween(this, {alpha: to}, duration, {ease: ease != null ? ease : FlxEase.sineInOut});
	}

	/** Tween the scroll speed smoothly. */
	public function tweenSpeed(to:Float, duration:Float = 1, ?ease:Float->Float):FlxTween
	{
		return FlxTween.tween(this, {speed: to}, duration, {ease: ease != null ? ease : FlxEase.sineInOut});
	}

	function updateVelocity():Void
	{
		var rad:Float = direction * FlxAngle_DEG_TO_RAD;
		velocity.set(Math.cos(rad) * speed, Math.sin(rad) * speed);
	}

	function set_speed(value:Float):Float
	{
		speed = value;
		updateVelocity();
		return speed;
	}

	function set_direction(value:Float):Float
	{
		direction = value;
		updateVelocity();
		return direction;
	}

	static inline var FlxAngle_DEG_TO_RAD:Float = 0.017453292519943295; // Math.PI / 180
}
