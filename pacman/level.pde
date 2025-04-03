class Level
{
	private String 	 _fileName;
	private String[] _fileStr;
	public  String 	 title;
	public  int      nbCol, nbRow;


	Level(String levelName)
	{
		_fileName = levelName;
		_fileStr  = loadStrings("data/levels/"+_fileName);

		title = _fileStr[0];
		nbCol = _fileStr[1].length();
		nbRow = _fileStr.length-1; 
	}

	public String[] getFile()
	{
		return _fileStr;
	}

	public String getName()
	{
		return _fileName;
	}
}

class Levels
{

	private ArrayList<Level> _levels;

	Levels()
	{
		_loadLevels();
	}

	private void _loadLevels()
	{
		_levels = new ArrayList<Level>();

		File levelsDir = new File(dataPath("/levels"));
		File[] levelsFiles = levelsDir.listFiles();

		for(File levelFile : levelsFiles)
		{
			if(levelFile.isFile())
			{
				String levelName = levelFile.getName();
				Level level = new Level(levelName);
				_levels.add(level);
			}
		}
	}

	public Level getLevel(String levelName)
	{
		Level l = new Level("level1.txt");

		for(Level level : _levels)
			if(level.getName().equals(levelName))
				l = level;

		return l;
	}

	public ArrayList<Level> getAllLevels()
	{
		return _levels;
	}
}