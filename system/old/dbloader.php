<?php

/**
* Blogza, the open source, simple to use blogging software.
*
* @author	boboman13 <me@boboman13.net>
* @version	1.0
**/
class DatabaseManager {

	private $mysqli;

	/* These are the cached query results. */
	private $posts = null;

	/**
	* Creates the DatabaseManager instance.
	*
	* @access	public
	* @return	DatabaseManager
	**/
	public function __construct() {
		$this->mysqli = mysqli_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE);

		// Check for error.
		if(mysqli_connect_errno($this->mysqli)) {
			die("Error: Could not connect to MySQL database.");
		}

	}

	/**
	* Creates and inserts the post into the database.
	*
	* @access public
	* @param	string	$author		The author of the post.
	* @param	string	$title 		The title of the post.
	* @param	string 	$content 	The content of the post.
	* @return boolean
	**/
	public function createPost($author = null, $title = null, $content = null) {
		// If any were null, throw an exception.
		if($author == null || $title == null || $content == null) {
			throw new Exception("The author, title, or content cannot be null!");
		}

		// Sanitize these inputs.
		$author  = mysqli_real_escape_string($author);
		$title   = mysqli_real_escape_string($title);
		$content = mysqli_real_escape_string($content);

		// Here is the query and execution.
		$query = "INSERT INTO `posts` (author, title, content) VALUES ('$author', '$title', '$content')";

		$result = $this->queryDB($query);

		// Give a result.
		if($result == true || $result == false) {
			return $result;
		} else {
			// Uh... why didn't it return true or false? Was it just bypassed?
			return false;
		}

	}

	/**
	* Gets all the posts in array format.
	*
	* @access	public
	* @return	mixed
	**/
	public function getPosts() {
		if($this->posts !== null) {
			// The program has already sent this query and we can return the cached result.
			return $this->posts;
		}

		$query = "SELECT * FROM `posts`"; // Direct query into DB, no variables.

		$result = $this->queryDB($query);

		/* Now we format it into our standard post format. */
		$posts = array();
		while($row = $result->fetch_assoc()) {
			$id = $row['id'];

			$posts[$id] = array(
				"id" => $id,
				"author" => $row['author'],
				"title" => $row['title'],
				"content" => $row['content'],
				"date" => $row['date'],
				"link" => "/post/".$id,
				);
		}

		$this->posts = $posts; // Assign cached variable.
		return $posts;
	}

	/**
	* Creates and inserts a new user into the database.
	*
	* @access	public
	* @param	string	$username	The user's display name. This is used for all blog posts.
	* @param	string	$password	The user's password. This will be hashed in this function.
	* @return	mixed
	**/
	public function createUser($username = null, $password = null) {
		// If any given variables were null, throw an exception.
		if($username == null || $password == null) {
			throw new Exception("The username or password cannot be null!");
		}

		// Sanitize.
		$username = mysqli_real_escape_string($username);
		$password = mysqli_real_escape_string($password);

		// Hash the password. (Iterate 16 times for security!)
		for($i = 0; $i < 16; $i++) {
			$password = hash('sha256', $password);
		}

		$query = "INSERT INTO `users` (user_name, user_password, user_posts) VALUES ('$username', '$password', '0')";

		$result = $this->queryDB($query);

		// Give a result.
		if($result == true || $result == false) {
			return $result;
		} else {
			// Uh... why didn't it return true or false? Was it just bypassed?
			return false;
		}
	}

	/**
	* Gets the user from the database.
	*
	* @access	public
	* @param	string	$username	The user's name.
	* @return	mixed	Returns the User object if found; null if not found.
	**/
	public function getUser($username) {
		$query = "SELECT * FROM `users`";

		$result = $this->queryDB($query);

		$found = false;
		// Lets find our user.
		while($row = $result->fetch_assoc()) {
			if($row['user_name'] == $username) $found = $row;
		}

		if($found == false) {
			// Return null
			return null;
		} else {
			// Make the user.
			$user = new User($found['user_name'], $found['user_password'], $found['user_posts']);
			return $user;
		}
	}

	/**
	* Querys the database.
	*
	* @access	private
	* @param	string 	$query 		The string of SQL to query the database with.
	* @return	mixed
	**/
	private function queryDB($query = null) {
		if($query == null) {
			throw new Exception("The query cannot be null!");
		}

		// Query!
		$result = mysqli_query($this->mysqli, $query);

		// Did we encounter an error?
		if( !$result ) {
			die("MySQL Query Error.");
		}

		return $result;
	}


	
}