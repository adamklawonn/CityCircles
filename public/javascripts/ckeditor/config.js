/*
Copyright (c) 2003-2009, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config )
{
	config.toolbar = 'CityCircles';
	config.width = "450";
	config.resize_enabled = false;
  config.toolbar_CityCircles =
  [
      ['Maximize','Cut','Copy','Paste','PasteText','PasteFromWord','-','Scayt'],
      ['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
      ['Link','Unlink','Anchor', '-','Image','Flash','Table','HorizontalRule','Smiley','SpecialChar','PageBreak'],
      '/',
      ['Styles','Format'],
      ['Bold','Italic','Strike'],
      ['NumberedList','BulletedList','-','Outdent','Indent','Blockquote']
  ];
};
