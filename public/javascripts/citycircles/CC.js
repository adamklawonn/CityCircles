(new function() {
	
	/*
	*	Defines the citycircles post utility function.
	*/
	
	citycircles.posts.add_attachment_field = function() {
		var attachmentsUlEl = $j("#post_attachments_files")[0];
		var nodeCount = 1;
		for(var i = 0; i < attachmentsUlEl.childNodes.length; i++) {
			if(attachmentsUlEl.childNodes[i].nodeName == "LI") {
				nodeCount += 1;
			}
		}

		var attachmentEl = document.createElement("LI");
		attachmentEl.setAttribute("style", "font-size: 0.9em;");
 		attachmentEl.innerHTML = 'Caption<br/><input type="text" name="post_attachment_captions[' + nodeCount + ']" /><br /><input type="file" name="post_attachment_files[' + nodeCount + ']" />';
		attachmentsUlEl.appendChild(attachmentEl);
	};

}());