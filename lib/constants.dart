import 'package:flutter/material.dart';

class Constants {
  // resource file path
  static final String logoWhite = 'assets/logo-white.svg';

  // color
  static const Color COLOR_BLUE_THEME = Color(0xFF1070A1);
  static const Color COLOR_BLUE_SECONDARY = Color(0xFF2948FF);
  static const Color COLOR_DARK_BLUE_INPUT_LABEL = Color(0xFF001694);
  static const Color COLOR_BLUE_SAPPHIRE = Color(0xFF066BA6);
  static const Color COLOR_BLUE_MEDIUM_STATE = Color(0xFF6E6DE4);
  static const Color COLOR_NEON_BLUE = Color(0xFF4763FF);
  static const Color COLOR_MAGNOLIA = Color(0xFFF0F2FF);
  static const Color COLOR_MIDNIGHT_BLUE = Color(0xFF01065E);
  static const Color COLOR_MEDIUM_SLATE_BLUE = Color(0xFF6E6DE4);
  static const Color COLOR_MEDIUM_BLUE = Color(0xFF440FC0);

  static const Color COLOR_PERIWINKLE_CRAYOLA = Color(0xFFD1DFFF);
  static const Color COLOR_ROYAL_PURPLE = Color(0xFF794F94);

  static const Color COLOR_SILVER_LIGHT = Color(0xFFC7C7C7);
  static const Color COLOR_SILVER_LIGHTER = Color(0xFFCACACA);
  static const Color COLOR_SONIC_SILVER = Color(0xFF6E6F70);

  static const Color COLOR_CULTURED = Color(0xFFF1F2F5);
  static const Color COLOR_PLATINUM = Color(0xFFEBEBEC);
  static const Color COLOR_PLATINUM_DARK = Color(0xFFE9ECEE);
  static const Color COLOR_PLATINUM_LIGHT = Color(0xFFE8E8E8);

  static const Color COLOR_GRAY_DIM = Color(0xFF636363);
  static const Color COLOR_GRAY_LIGHT = Color(0xFF757575);
  static const Color COLOR_GRAY_BOX_SHADOW = Color(0xFFDDDDDD);

  static const Color COLOR_RED = Color(0xFFFF0000);
  static const Color COLOR_ORANGE_PANTONE = Color(0xFFFF6006);
  static const Color COLOR_MAXIMUM_YELLOW_RED = Color(0xFFFFBB43);
  static const Color COLOR_FLAME = Color(0xFFE35C36);

  static const Color COLOR_RAZZLE_DAZZLE_ROSE = Color(0xFFFF43C7);

  static const Color COLOR_GREEN_LIGHT = Color(0xFF28A745);
  static const Color COLOR_ILLUMINATING_EMERALD = Color(0xFF3C8D7E);
  static const Color COLOR_TURQUOISE = Color(0xFF34DFD2);

  static const Color COLOR_BLACK_CORAL = Color(0xFF4E545F);

  static const Color COLOR_WHITE = Colors.white;
  static const Color COLOR_BLACK = Colors.black;

  // color swatch
  static const MaterialColor colorBlueSecondarySwatch = const MaterialColor(
    0xFF2948FF,
    const<int, Color>{
      50: const Color(0xFF2948FF),
      100: const Color(0xFF2948FF),
      200: const Color(0xFF2948FF),
      300: const Color(0xFF2948FF),
      400: const Color(0xFF2948FF),
      500: const Color(0xFF2948FF),
      600: const Color(0xFF2948FF),
      700: const Color(0xFF2948FF),
      800: const Color(0xFF2948FF),
      900: const Color(0xFF2948FF),
    }
  );

  // other text style
  static const TextStyle TEXT_STYLE_HEADING_1 = TextStyle(
    fontSize: 26.0,
    fontWeight: FontWeight.w800,
    fontFamily: 'Nunito',
    color: COLOR_BLACK,
  );
  static const TextStyle TEXT_STYLE_HEADING_WHITE_1 = TextStyle(
    fontSize: 26.0,
    fontWeight: FontWeight.w800,
    fontFamily: 'Nunito',
    color: COLOR_WHITE,
  );
  static const TextStyle TEXT_STYLE_HEADING_2 = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w700,
    fontFamily: 'Nunito',
    color: COLOR_BLACK
  );
    static const TextStyle TEXT_STYLE_HEADING_3 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    fontFamily: 'Nunito',
    color: COLOR_BLACK
  );
  static const TextStyle TEXT_STYLE_HEADING_4 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    fontFamily: 'Nunito',
    color: COLOR_BLACK,
  );
  static const TextStyle TEXT_STYLE_HEADING_SUBTITLE_1 = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    fontFamily: 'Nunito',
    color: COLOR_WHITE,
  );
  static const TextStyle TEXT_STYLE_SUB_HEADING_1 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    fontFamily: 'Nunito',
    color: COLOR_GRAY_LIGHT
  );
  static const TextStyle TEXT_STYLE_SUB_HEADING_2 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    fontFamily: 'Nunito',
    color: COLOR_GRAY_LIGHT
  );
  static const TextStyle TEXT_STYLE_SUB_HEADING_3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    fontFamily: 'Nunito',
    color: COLOR_GRAY_LIGHT
  );
  static const TextStyle TEXT_STYLE_SUB_HEADING_BOLD_1 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    fontFamily: 'Nunito',
    color: COLOR_GRAY_LIGHT,
  );
  static final TextStyle textStyleInputLabel = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w800,
    fontFamily: 'Nunito',
    color: COLOR_DARK_BLUE_INPUT_LABEL
  );
  static const TextStyle TEXT_STYLE_INPUT_HINT_1 = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    fontFamily: 'Nunito',
    color: COLOR_SILVER_LIGHT
  );
  static const TextStyle TEXT_STYLE_INPUT_HINT_2 = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    fontFamily: 'Nunito',
    color: COLOR_GRAY_LIGHT
  );
  static const TextStyle TEXT_STYLE_INPUT_HINT_3 = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    fontFamily: 'Nunito',
    color: COLOR_GRAY_LIGHT
  );
  static const TextStyle TEXT_STYLE_INPUT_TEXT_1 = TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'Nunito',
    color: COLOR_GRAY_LIGHT,
  );
  static const TextStyle TEXT_STYLE_INPUT_TEXT_2 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'Nunito',
    color: COLOR_BLACK,
  );
  static final TextStyle textStyleInputHintDarker = TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w500,
      fontFamily: 'Nunito',
      color: COLOR_GRAY_DIM
  );
  static final TextStyle textStyleForgotPasswordText = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w800,
    fontFamily: 'Nunito',
    color: COLOR_BLUE_SECONDARY
  );
  static const TextStyle TEXT_STYLE_BUTTON_TEXT = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w800,
    fontFamily: 'Nunito',
    color: COLOR_WHITE
  );
  static final TextStyle textStyleSignUpText1 = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'Nunito',
    color: COLOR_BLACK
  );
  static final TextStyle textStyleSignUpText2 = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w800,
    fontFamily: 'Nunito',
    color: COLOR_BLUE_SECONDARY
  );
  static const TextStyle TEXT_STYLE_FORGOT_PASSWORD_EMAIL_OPTION_TEXT = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    fontFamily: 'Nunito',
    color: COLOR_BLUE_SECONDARY
  );
  static const TextStyle TEXT_STYLE_DROPDOWN_HINT_1 = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    fontFamily: 'Nunito',
    color: COLOR_BLACK
  );
  static const TextStyle TEXT_STYLE_DROPDOWN_HINT_2 = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    fontFamily: 'Nunito',
    color: COLOR_BLACK
  );
  static const TextStyle TEXT_STYLE_NUM_PAD = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: COLOR_BLACK
  );
  static const TextStyle TEXT_STYLE_NUM_PAD_EMPTY = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: Colors.transparent
  );
  static const TextStyle TEXT_STYLE_SUB_TITLE_1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: 'Nunito',
    color: COLOR_GRAY_LIGHT,
  );
  static const TextStyle TEXT_STYLE_FILTER_DROPDOWN_TEXT = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    fontFamily: 'Nunito',
    color: COLOR_BLACK,
  );
  static const TextStyle TEXT_STYLE_BOOK_LIST_TITLE = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    fontFamily: 'Nunito',
    color: COLOR_BLACK,
  );
  static const TextStyle TEXT_STYLE_VERSION_TEXT = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    fontFamily: 'Nunito',
    color: COLOR_BLACK,
  );
  static const TextStyle TEXT_STYLE_BOOK_LIST_SUB_TITLE_1 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    fontFamily: 'Nunito',
    color: COLOR_BLACK,
  );
  static const TextStyle TEXT_STYLE_BOOK_LIST_SUB_TITLE_2 = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    fontFamily: 'Nunito',
    color: COLOR_BLACK,
  );
  static const TextStyle TEXT_STYLE_BOOK_LIST_SUB_TITLE_3 = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    fontFamily: 'Nunito',
    color: COLOR_GRAY_DIM,
  );
  static const TextStyle TEXT_STYLE_BOOK_LIST_SUB_TITLE_BOLD_3 = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    fontFamily: 'Nunito',
    color: COLOR_GRAY_DIM,
  );
  static const TextStyle TEXT_STYLE_SEARCHING = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    fontFamily: 'Nunito',
    color: COLOR_BLACK
  );
  static const TextStyle TEXT_STYLE_SEARCH_DROPDOWN = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    fontFamily: 'Nunito',
    color: COLOR_BLACK,
  );
  static const TextStyle TEXT_STYLE_BOOK_DETAILS_TITLE = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    fontFamily: 'Nunito',
    color: COLOR_BLACK
  );
  static const TextStyle TEXT_STYLE_BOOK_DETAILS_AUTHOR = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'Nunito',
    color: COLOR_BLACK
  );
  static const TextStyle TEXT_STYLE_PROPERTY_TEXT = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'Nunito',
    color: COLOR_BLACK
  );
  static const TextStyle TEXT_STYLE_DETAILS_ACTION_BUTTON_TEXT = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'Nunito',
    color: COLOR_WHITE
  );
  static const TextStyle TEXT_STYLE_DETAILS_TAB_BAR_TEXT_SELECTED = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    fontFamily: 'Nunito',
  );
  static const TextStyle TEXT_STYLE_DETAILS_TAB_BAR_TEXT_UNSELECTED = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    fontFamily: 'Nunito',
    color: COLOR_GRAY_LIGHT,
  );
  static const TextStyle TEXT_STYLE_DETAILS_TABLE_TITLE = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w800,
    fontFamily: 'Nunito',
    color: COLOR_BLACK
  );
  static const TextStyle TEXT_STYLE_DETAILS_TABLE_CONTENT = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'Nunito',
    color: COLOR_BLACK
  );
  static const TextStyle TEXT_STYLE_DETAILS_TABLE_CONTENT_HIGHLIGHT = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'Nunito',
    color: COLOR_NEON_BLUE
  );
  static const TextStyle TEXT_STYLE_DETAILS_PASSAGE_CONTENT_1 = TextStyle(
    fontSize: 16.0,
    height: 1.8,
    fontWeight: FontWeight.w600,
    fontFamily: 'Nunito',
    color: COLOR_BLACK,
  );
  static const TextStyle TEXT_STYLE_DETAILS_PASSAGE_CONTENT_2 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'Nunito',
    color: COLOR_BLACK,
  );
  static const TextStyle TEXT_STYLE_DETAILS_PASSAGE_CONTENT_3 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'Nunito',
    color: COLOR_BLACK,
  );
  static const TextStyle TEXT_STYLE_DETAILS_PASSAGE_CONTENT_WHITE_2 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'Nunito',
    color: COLOR_WHITE,
  );
  static const TextStyle TEXT_STYLE_DETAILS_PASSAGE_CONTENT_SMALL_TITLE_WHITE_1 = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w700,
    fontFamily: 'Nunito',
    color: COLOR_WHITE,
  );
  static const TextStyle TEXT_STYLE_DETAILS_PASSAGE_CONTENT_SMALL_TITLE_1 = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w700,
    fontFamily: 'Nunito',
    color: COLOR_BLACK,
  );
  static const TextStyle TEXT_STYLE_DETAILS_PASSAGE_CONTENT_SMALL_TITLE_2 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
    fontFamily: 'Nunito',
    color: COLOR_BLACK,
  );
  static const TextStyle TEXT_STYLE_DETAILS_PASSAGE_CONTENT_SMALL_WHITE_1 = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'Nunito',
    color: COLOR_WHITE,
  );
  static const TextStyle TEXT_STYLE_DETAILS_PASSAGE_CONTENT_SMALL_1 = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'Nunito',
    color: COLOR_BLACK,
  );
  static const TextStyle TEXT_STYLE_NON_ALTERNATIVE_TEXT = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: 'Nunito',
    color: COLOR_BLACK,
  );
  static const TextStyle TEXT_STYLE_CARD_TITLE_1 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
    fontFamily: 'Nunito',
    color: COLOR_BLACK,
  );
  static const TextStyle TEXT_STYLE_CARD_TITLE_2 = TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w800,
    fontFamily: 'Nunito',
    color: COLOR_WHITE,
  );
  static const TextStyle TEXT_STYLE_CARD_TITLE_3 = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'Nunito',
    color: COLOR_BLACK,
  );
  static const TextStyle TEXT_STYLE_CARD_TITLE_4 = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w700,
    fontFamily: 'Nunito',
    color: COLOR_BLACK,
  );
  static const TextStyle TEXT_STYLE_CARD_TITLE_5 = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
    fontFamily: 'Nunito',
    color: COLOR_BLACK,
  );
  static const TextStyle TEXT_STYLE_CARD_SUB_TITLE_1 = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'Nunito',
    color: COLOR_GRAY_LIGHT,
  );
  static const TextStyle TEXT_STYLE_CARD_SUB_TITLE_2 = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w800,
    fontFamily: 'Nunito',
    color: COLOR_WHITE,
  );
  static const TextStyle TEXT_STYLE_CARD_SUB_TITLE_3 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'Nunito',
    color: COLOR_BLACK,
  );
  static const TextStyle TEXT_STYLE_CARD_SUB_TITLE_4 = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'Nunito',
    color: COLOR_BLACK,
  );
  static const TextStyle TEXT_STYLE_CARD_SUB_TITLE_5 = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
    fontFamily: 'Nunito',
    color: COLOR_BLACK,
  );
  static const TextStyle TEXT_STYLE_CARD_SUB_TITLE_6 = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'Nunito',
    color: COLOR_BLACK,
  );
  static const TextStyle TEXT_STYLE_CARD_SUB_TITLE_7 = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'Nunito',
    color: COLOR_BLACK,
  );
  static const TextStyle TEXT_STYLE_CARD_SUB_TITLE_8 = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'Nunito',
    color: COLOR_GRAY_LIGHT,
  );
  static const TextStyle TEXT_STYLE_CARD_SUB_TITLE_BOLD_6 = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w700,
    fontFamily: 'Nunito',
    color: COLOR_BLACK,
  );
  static const TextStyle TEXT_STYLE_CARD_DATE_1 = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w700,
    fontFamily: 'Nunito',
    color: COLOR_GRAY_LIGHT,
  );
  static const TextStyle TEXT_STYLE_CARD_ADDRESS_DATE_2 = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'Nunito',
    color: COLOR_GRAY_LIGHT,
  );
  static const TextStyle TEXT_STYLE_CARD_DATE_3 = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'Nunito',
    color: COLOR_GRAY_LIGHT,
  );
  static const TextStyle TEXT_STYLE_CARD_DATE_4 = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w700,
    fontFamily: 'Nunito',
    color: COLOR_GRAY_LIGHT,
  );
  static const TextStyle TEXT_STYLE_CARD_DATE_5 = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'Nunito',
    color: COLOR_BLACK,
  );
  static const TextStyle TEXT_STYLE_CARD_DAY_SECTION_TITLE = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'Nunito',
    color: COLOR_GRAY_LIGHT,
  );
  static const TextStyle TEXT_STYLE_FLOATING_BUTTON_LIST_TEXT = TextStyle(
    fontFamily: 'Nunito',
    color: COLOR_WHITE,
  );
  static const TextStyle TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1 = TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w800,
  );
  static const TextStyle TEXT_STYLE_DIALOG_TITLE_AND_ACTION_2 = TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w800,
    color: COLOR_RED,
  );
  static const TextStyle TEXT_STYLE_DIALOG_CONTENT = TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w600,
    color: COLOR_BLACK,
  );
  static const TextStyle TEXT_STYLE_DIALOG_CONTENT_BOLD = TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w800,
    color: COLOR_BLACK,
  );
  static const TextStyle TEXT_STYLE_MORE_OPTIONS_TEXT = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w700,
    fontFamily: 'Nunito',
    color: COLOR_BLACK,
  );
  static const TextStyle TEXT_STYLE_SETTING_OPTION_TEXT = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'Nunito',
    color: COLOR_BLACK,
  );
  static const TextStyle TEXT_STYLE_PROFILE_NAME_TEXT = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w700,
    fontFamily: 'Nunito',
    color: COLOR_BLACK,
  );
  static const TextStyle TEXT_STYLE_MORE_OPTIONS_RED_TEXT = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w700,
    fontFamily: 'Nunito',
    color: COLOR_RED,
  );
  static const TextStyle TEXT_STYLE_BADGE_TEXT = TextStyle(
    color: COLOR_WHITE,
  );
  static const TextStyle TEXT_STYLE_INVALID_INPUT_TEXT = TextStyle(
    fontFamily: 'Nunito',
    color: COLOR_RED,
  );
  static const TextStyle TEXT_STYLE_SNACK_BAR_CONTENT = TextStyle(
    fontWeight: FontWeight.w600,
    fontFamily: 'Nunito',
    color: COLOR_WHITE,
  );
  static const TextStyle TEXT_STYLE_TEXT_BUTTON = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w700,
    fontFamily: 'Nunito',
    color: COLOR_BLUE_SECONDARY,
  );
  static const TextStyle TEXT_STYLE_SWITCH_TEXT = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: 'Nunito',
    color: COLOR_WHITE,
    fontSize: 12.0,
  );
  static const TextStyle TEXT_STYLE_DEVICE_NAME_TEXT = TextStyle(
    fontWeight: FontWeight.w600,
    fontFamily: 'Nunito',
    color: COLOR_GRAY_LIGHT,
    fontSize: 16.0,
  );
}