class Score
{
	private String _username;
	private String _type;
	private int _points;

	Score(String result)
	{
		String[] result_splited = split(result, "|");
		_username = result_splited[0];
		_type		  = result_splited[1];
		_points 	= int(result_splited[2]);
	}

	public String getUsername()
	{
		return _username;
	}

	public String getType()
	{
		return _type;
	}

	public int getPoints()
	{
		return _points;
	}
}

class Scores
{
	private String _file;
	private ArrayList<Score> _scores;

	Scores()
	{
		_scores = new ArrayList<Score>();
		_updateScores();
	}

	private void _updateScores()
	{
		String[] strings = loadStrings("data/scores/scores.txt");
		_file = strings[0];
		String[] scores = split(_file,";");

		for(int i=0; i < scores.length; i++)
			_scores.add(new Score(scores[i]));

		Collections.sort(_scores, new Comparator<Score>(){
			public int compare(Score s1, Score s2) 
			{
	  		int scorepoints1 = s1.getPoints();
	  		int scorepoints2 = s2.getPoints();
	  		return scorepoints2-scorepoints1;
  		}
		});
	}

	public void addScore(String newScore)
	{
		_file += newScore;
		String[] strings = {_file};
		saveStrings("data/scores/scores.txt", strings);

		_updateScores();
	}

	public ArrayList<Score> getScoresAbout(String about)
	{
		ArrayList<Score> scoresBy = new ArrayList<Score>();

		for(Score _score : _scores){
			switch(about){
				case "victories": if(_score.getType().equals("V")) scoresBy.add(_score); break;
				case "losses": 		if(_score.getType().equals("D")) scoresBy.add(_score); break;
			}
		}
		return scoresBy;
	}

	public ArrayList<Score> getScores()
	{
		return _scores;
	}
}