/**
 * {@link https://www.youtube.com/watch?v=c8sc_w-g3-A }
 */
class KTimer
{
	private float _time;

	KTimer(float t)
	{
		_time = t;
	}

	public float getTime()
	{
		return _time;
	}

	public void setTime(float t)
	{
		_time = t;
	}

	public void countUp()
	{
		_time += 1 / frameRate;
	}

	public void countDown()
	{
		_time -= 1 / frameRate;
	}
}