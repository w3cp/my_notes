import 'package:flutter/material.dart';

class UIData {
  //routes
  static const String initialRoute = "/";
  static const String routeAddEditNote = "'/add_note'";
  static const String routeNoteDetails = "/add_note";

  //strings
  static const String appName = "My Notes";
  //route title
  static const String titleRouteNoteDetails = "Note Details";
  static const String titleRouteAddNewNote = "Add New Note";
  static const String titleRouteEditNote = "Edit Note";

  //drawer
  static const String drawerAllNotes = "All Notes";
  static const String drawerFavoriteNotes = "Favorite Notes";

  //actions
  static const String actionDelete = "delete";
  static const String actionEdit = "edit";

  //fonts
  static const String quickFont = "Quicksand";
  static const String ralewayFont = "Raleway";
  static const String quickBoldFont = "Quicksand_Bold.otf";
  static const String quickNormalFont = "Quicksand_Book.otf";
  static const String quickLightFont = "Quicksand_Light.otf";

  //images
  static const String imageDir = "assets/images";
  static const String profileImage = "$imageDir/profile.jpg";

  //login
  static const String enter_code_label = "Phone Number";
  static const String enter_code_hint = "10 Digit Phone Number";
  static const String enter_otp_label = "OTP";
  static const String enter_otp_hint = "4 Digit OTP";
  static const String get_otp = "Get OTP";
  static const String resend_otp = "Resend OTP";
  static const String login = "Login";
  static const String enter_valid_number = "Enter 10 digit phone number";
  static const String enter_valid_otp = "Enter 4 digit otp";

  //gneric
  static const String error = "Error";
  static const String success = "Success";
  static const String ok = "OK";
  static const String forgot_password = "Forgot Password?";
  static const String something_went_wrong = "Something went wrong";
  static const String coming_soon = "Coming Soon";

  //form
  static const String formErrorEmtyTitle = "Please enter note title";
  static const String formErrorEmtyDescription =
      "Please enter note description";
  static const String formLebelTitle = "Note title";
  static const String formHintTitle = "Write your note title";
  static const String formLebelBody = "Note body";
  static const String formHintBody = "Write your note here";
  static const String formHintSearchNote = "Search Note...";

  //raised button
  static const String raisedButtonSave = "Save";
  static const String raisedButtonUpdate = "Update";

  //snackbar string
  static const String snackbarNoteCreateSuccess = "Note successfully created";
  static const String snackbarNoteUpdateSuccess = "Note successfully updated";
  static const String snackbarNoteDeleteSuccess = "Note deleted";
  static const String snackbarNoteAddToFavorite =
      "Note successfully added to favorite";
  static const String snackbarNoteRemoveFromFavorite =
      "Note successfully removed from favorite";

  //tooltip string
  static const String tooltipAddNewNote = "Add New Note";
  static const String tooltipDeleteNote = "Delete Note";
  static const String tooltipEditNote = "Edit Note";
  static const String tooltipSaveNote = "Save Note";
  static const String tooltipUpdateNote = "Update Note";
  static const String tooltipSearchNote = "Search Note";
  static const String tooltipAddToFavorite = "Add to favorite";
  static const String tooltipRemoveFromFavorite = "Remove from favorite";

  //lebel string
  static const String lebelUndo = "Undo";

  //other strings
  static const String lastModified = "Last modified";

  //theme
  static final TextStyle quickFontTheme = TextStyle().copyWith(fontFamily: UIData.quickFont);
  static final Color backgroundColor = Colors.grey.shade900;
}
