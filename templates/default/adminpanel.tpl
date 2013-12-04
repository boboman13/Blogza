<html>

	<head>
		<title>{$blog.name} :: Admin Panel</title>

		<link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Ubuntu">
		<link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Fenix">

		<link rel="stylesheet" href="{$blog.folder}/templates/{$template.name}/css/bootstrap.min.css">
		<link rel="stylesheet" href="{$blog.folder}/templates/{$template.name}/css/blog.css">
		<link rel="stylesheet" href="{$blog.folder}/templates/{$template.name}/css/admin.css">
		<meta name="description" content="{$blog.description}" />
		<meta name="author" content="boboman13" />
	</head>

	<body class="admin">
		<div class="container-fluid">
			<div class="row-fluid">
				<div class="span4 block">
					<h3>{$vars.time}</h3>
					<p>Hello, {$user.user}.</p>
					<br />
					<a class="btn btn-admin" href="{$blog.url}/"><i class="icon-chevron-left"></i> Return</a>
				</div>
				<div class="span4 block">
					<h3>Updates</h3>
					<p>You are running <strong>1.4.2</strong>.</p>
					<p>The latest is <strong>1.4.3</strong>.</p>
				</div>
				<div class="span4 block">

				</div>
			</div>
			<div class="row-fluid">
				<div class="span4 block">
					<form method="post" action="{$blog.url}/admin/create-post" class="form-fill" id="create-post">
						<div class="alert msg"> </div>

						<h3>New Post <img class="loader" src="{$blog.folder}/templates/{$template.name}/img/ajax-loader.gif" width="16px" height="16px" /></h3>

						<input id="title" type="text" name="title" value="Post title..."> </input>
						<textarea id="content" name="content" rows="5">Post content...</textarea>

						<div class="row-fluid">
							<div class="span3">
								<a href="#" class="btn btn-primary btn-block btn-admin" id="edit-btn"><i class="icon-align-left"></i> Editor</a>
							</div>
							<div class="span9">
								<input type="submit" value="Create Post" class="btn btn-admin btn-success btn-block"> </input>
							</div>
						</div>
					</form>
				</div>
				<div class="span4 block">
					<h3>Posts Status</h3>

					<div class="posts-breakdown">
						<p><strong class="done">6</strong> Finished</p>
						<p><strong class="draft">2</strong> Drafts</p>
						<p><strong class="trash">3</strong> Trashed</p>
					</div>

				</div>
				<div class="span4 block">
					<h3>Latest Comments</h3>

					<table class="table table-bordered table-hold">
						<thead>
							<tr>
								<th>Poster</th>
								<th>Content</th>
								<th>Vote</th>
							</tr>
						</thead>
						<tbody>
							{foreach $vars.comments as $comment}

							<tr id="comment-{$comment->id}">
								<td>{$comment->author->getUsername()}</td>
								<td>{$comment->content}</td>
								<td>
									<a href="#ok.{$comment->id}" class="vote-btn btn btn-admin btn-fill btn-success">
										<i class="icon-ok"> </i>
									</a>
									<a href="#remove.{$comment->id}" class="vote-btn btn btn-admin btn-fill btn-danger">
										<i class="icon-remove"> </i>
									</a>
								</td>
							</tr>

							{/foreach}
						</tbody>
					</table>

				</div>
			</div>
			<div class="row-fluid">
				<div class="span4 block">
					<h3>Manage Users</h3>
					<table class="table table-bordered">
						<thead>
							<tr>
								<th>Username</th>
								<th>Rank</th>
							</tr>
						</thead>
						<tbody>
							{foreach $vars.users as $nerp => $user}
							<tr>
								<td>{$user->getUsername()}</td>
								<td>{$user->getRank()}</td>
							</tr>
							{/foreach}
						</tbody>
					</table>

				</div>
				<div class="span4 block">
					<h3>Edit Posts</h3>

					<table class="table table-bordered table-hold">
						<thead>
							<tr>
								<th>Action</th>
								<th>Author</th>
								<th>Title</th>
							</tr>
						</thead>
						<tbody>
							{foreach $vars.posts as $post name=posts}
							{if $smarty.foreach.posts.index == 5}
								{break}
							{/if}
							<tr>
								<td>
									<a href="#edit.{$post->id}" class="edit-btn btn btn-admin btn-fill btn-success">
										<i class="icon-pencil"> </i>
									</a>
								</td>
								<td>{$post->author->getUsername()}</td>
								<td id="post-{$post->id}">{$post->title}</td>
							</tr>
							{/foreach}
						</tbody>
					</table>

				</div>
				<div class="span4 block">

				</div>
			</div>
		</div>

		<div class="modal hide" id="edit-post">
			<form method="post" action="{$blog.url}/admin/update-post" class="form-fill" id="edit-post-form">
				<div class="modal-header">
					<button type="button" class="close">&times;</button>
					<h3>Edit Post <img class="loader" src="{$blog.folder}/templates/{$template.name}/img/ajax-loader.gif" width="16px" height="16px" /><h3>
				</div>
				<div class="modal-body">
					<div class="alert msg"> </div>
					<h2 name="title">Title</h2>

					<input type="hidden" value="" name="id" />

					<div>
					</div>

					<textarea class="content" rows="15"></textarea>

				</div>
				<div class="modal-footer">
					<input type="submit" class="btn btn-admin btn-success btn-block" value="Update Post"> </input>

				</div>

			</form>
		</div>	

		<div class="modal hide" id="post-editor">

			<form method="post" action="{$blog.url}/admin/create-post" class="form-fill" id="post-editor-form">
				<div class="modal-header">
					<button type="button" class="close">&times;</button>
					<h3>Post Creation <img class="loader" src="{$blog.folder}/templates/{$template.name}/img/ajax-loader.gif" width="16px" height="16px" /></h3>

				</div>
				<div class="modal-body form-fill">
					<div class="alert msg"> </div>

					<input type="text" placeholder="Title" name="title"> </input>

					<div class="edit-tools">
						<a href="#"> <i class="icon-bold"> </i> </a>
						<a href="#"> <i class="icon-italic"> </i> </a>
						<a href="#"> <i class="icon-text-height"> </i> </a>

						<div class="separator"> </div>

						<a href="#"> <i class="icon-align-left"> </i> </a>
						<a href="#"> <i class="icon-align-center"> </i> </a>
						<a href="#"> <i class="icon-align-right"> </i> </a>
					</div>
					<textarea name="content" rows="15"></textarea>

				</div>
				<div class="modal-footer">
					<input type="submit" class="btn btn-admin btn-success btn-block" value="Create Post"> </input>


				</div>
			</form>
		</div>

		<noscript>
			<style> .container-fluid { opacity: 0.2; } body { background: #222 !important; } </style>
			<div class="alert alert-error popup">
				<h3>Error!</h3>

				<p>Your browser does not support Javascript. You must be running Javascript to use the admin panel. <a href="http://enable-javascript.com" target="_blank">Learn how here.</a></p>
			</div>
		</noscript>

		<script src="http://jqueryjs.googlecode.com/files/jquery-1.2.6.min.js"> </script>
		<script src="{$blog.folder}/templates/{$template.name}/js/admin.js"> </script>

	</body>

</html>