class KRandom
{
	private float _rand;

	KRandom(){}

	private void _generateRand()
	{
		_rand = random(0, 100);
	}

	private float _cut(int in)
	{
		return 100 / in;
	}

	public int krandom(ArrayList<Integer> list)
	{
		_generateRand();
		float piece = _cut(list.size());

		ArrayList<Float> pieces = new ArrayList<Float>();
		for(int i=1; i <= list.size(); i++)
			pieces.add(piece*i);

		for(int i=0; i < pieces.size(); i++)
			if(_rand <= pieces.get(i))
				return list.get(i);

		return list.get(0);
	}

	public int krandom(int[] list)
	{
		_generateRand();
		float piece = _cut(list.length);

		ArrayList<Float> pieces = new ArrayList<Float>();
		for(int i=1; i <= list.length; i++)
			pieces.add(piece*i);

		for(int i=0; i < pieces.size(); i++)
			if(_rand <= pieces.get(i))
				return list[i];
			
		return list[0];
	}


}