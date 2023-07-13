import 'package:ap_lib/search_catalogue/book_data_fetcher.dart';
import 'package:ap_lib/search_catalogue/book_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:ap_lib/search_catalogue/book_list.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_flare/smart_flare.dart';
import 'package:humanize/humanize.dart' as humanize;
import 'package:qrscan/qrscan.dart' as scanner;

import '../constants.dart';

enum SearchState {
  Idle,
  Searching,
  Found,
  NotFound
}

class SearchCataloguePage extends StatefulWidget {
  @override
  _SearchCataloguePageState createState() => _SearchCataloguePageState();
}

class _SearchCataloguePageState extends State<SearchCataloguePage> {
  int _resultNumber = 0;
  String _selectedCollection = "none";
  String _selectedCollectionText = "Material";

  String _selectedKeyword = "all";
  String _selectedKeywordText = "All";

  String _selectedSubject = "none";
  String _selectedSubjectText = "Subject";

  String _selectedAvailability = "none";
  String _selectedAvailabilityText = "Availability";

  String _sortingOption = "none";

  String _searchText = "";

  SearchState _searchState = SearchState.Found;

  var formatter = NumberFormat('###,###,###,###,###,###');

  bool _isLoading = false;

  BookDataFetcher _bookDataFetcher;
  ScrollController _scrollController = new ScrollController();
  TextEditingController _startingYearController = new TextEditingController();
  TextEditingController _endingYearController = new TextEditingController();
  TextEditingController _searchController = new TextEditingController();

  List<String> _keywordList = [
    'All,all',
    'Publication,publication',
    'ISBN,isbn',
    'Author,author',
    'Title,title',
    'Subject,subject'
  ];

  List<String> _materialTypeList = [
    'Material,none',
    'Print Book,CL001',
    'eBook,CL002'
  ];

  List<String> _subjectList = [
    'Subject,none',
    'Internet of things,SB001',
    'Computer networks,SB002',
    'Cisco IOS,SJ003',
    'Security measures, SB004',
    'Macroeconomics,SB005',
    'Mathematical statistics,SB006',
    'Probabilities,SB007',
    'Probability and statistics,SB008',
    'Regression analysis,SB009',
    'Java,SB010',
    'Internet programming,SB011',
    'Reliability (Engineering),SB012',
    'Quality control,SB013',
    'Databases,SB014',
    'Software patterns,SB015',
    'Data structures (Computer science),SB016',
    'Customer relations,SB017',
    'Electronic commerce,SB018',
    'Animation (Cinematography),SB019',
    'Art in motion pictures,SB020',
    'Labor supply,SB021',
    'Organisational change,SB022',
    'Data encryption (Computer science),SB023',
    'Cloud computing,SB024',
    'Computer crimes,SB025',
    'Android,SB026',
    'Application software,SB027',
    'Smartphones,SB028',
    'Computer operating systems,SB029',
    'Computers and IT,SB030',
    'Technical writing,SB031',
    'Business writing,SB032',
    'English language,SB033',
    'Computer games,SB034',
    'Mobile computing,SB035',
    'Microsoft and .NET,SB036',
    'iOS,SB037',
    'Flash (Computer file),SB038',
    'Swift,SB039',
    'Computer software,SB040',
    'Data recovery,SB041'
  ];

  List<String> _availabilityList = [
    'Availability,none',
    'Available,1',
    'Not Available,0'
  ];

  List<String> _sortOptionList = [
    'Default,none',
    '-',
    'Title (A-Z),book_title-ASC',
    'Title (Z-A),book_title-DESC',
    '-',
    'Author (A-Z),book_author-ASC',
    'Author (Z-A),book_author-DESC',
    '-',
    'Publication Year (Oldest to Newest),publishing_year-ASC',
    'Publication Year (Newest to Oldest),publishing_year-DESC'
  ];

  List<BookList> _resultBookList = [];

  _applyMaterialTypeFilter(String materialType) {
    setState(() {
      _selectedCollection = materialType;
      if (_selectedCollection == "none") {
        _selectedCollectionText = "Material";
      } else {
        _materialTypeList.forEach((element) {
          if (element.contains(materialType)) {
            var part = element.split(',');
            _selectedCollectionText = part[0];
          }
        });
      }
    });
    _searchHandler();
  }

  _applyKeywordFilter(String keyword) {
    setState(() {
      _selectedKeyword = keyword;
      if (_selectedKeyword == 'all') {
        _selectedKeywordText = 'All';
      } else {
        _keywordList.forEach((element) {
          if (element.contains(keyword)) {
            var part = element.split(',');
            _selectedKeywordText = part[0];
          }
        });
      }
    });
    _searchHandler();
  }

  _applySubjectFilter(String subject) {
    setState(() {
      _isLoading = false;
      _selectedSubject = subject;
      if (_selectedSubject == "none") {
        _selectedSubjectText = "Subject";
      } else {
        _subjectList.forEach((element) {
          var part = element.split(',');
          if (part[1] == subject) {
            _selectedSubjectText = part[0];
          }
        });
      }
    });
    _searchHandler();
  }

  _applyAvailabilityFilter(String availability) {
    setState(() {
      _selectedAvailability = availability;
      if (_selectedAvailability == "none") {
        _selectedAvailabilityText = "Availability";
      } else {
        _availabilityList.forEach((element) {
          var part = element.split(',');
          if (part[1] == _selectedAvailability) {
            _selectedAvailabilityText = part[0];
          }
        });
      }
    });
    _searchHandler();
  }
  
  _applySortingOption(String option) {
    setState(() {
      _sortingOption = option;
    });
    _searchHandler();
  }

  // handle search event, it is called in the first attempt
  _searchHandler() {
    if (_searchText.length != 0) {
      // change to loading state
      setState(() {
        _searchState = SearchState.Searching;
      });
      // fetch result
      _bookDataFetcher.executeSearch(
        _selectedKeyword,
        "0",
        _searchText.trim(),
        _selectedCollection,
        _startingYearController.text.trim() == ""
            ? "none"
            : _startingYearController.text.trim(),
        _endingYearController.text.trim() == ""
            ? "none"
            : _endingYearController.text.trim(),
        _selectedSubject,
        _selectedAvailability,
        _sortingOption
      ).then((list) =>
      {
        // set the loading state
        setState(() {
          _resultBookList.removeRange(0, _resultBookList.length);
          // check if there is a result found
          if (list.length == 0) {
            _searchState = SearchState.NotFound;
            _resultNumber = list.length;
          } else {
            _searchState = SearchState.Found;
          }
        }),
        // get the results and append them to the list
        list.forEach((element) {
          setState(() {
            _resultNumber = int.parse(list[0].resultFound);
            _resultBookList.add(element);
          });
        })
      });
    }
  }

  // fetch the next five results
  _fetchNewResult() {
    // set loading state
    setState(() {
      _isLoading = true;
    });
    // fetch new result
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (_resultBookList.length < _resultNumber) {
        _bookDataFetcher.executeSearch(
          _selectedKeyword,
          _resultBookList.length.toString(),
          _searchText,
          _selectedCollection,
          _startingYearController.text.trim() == "" ? "none" : _startingYearController.text.trim(),
          _endingYearController.text.trim() == "" ? "none" : _endingYearController.text.trim(),
          _selectedSubject,
          _selectedAvailability,
          _sortingOption
        ).then((list) => {
          // get the list and insert them to a list
          list.forEach((element) {
            setState(() {
              _resultBookList.add(element);
            });
          })
        });
      }
    }
  }

  _viewDetails(String itemId, Image imageData) async {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => BookDetailsPage(imageData: imageData, itemId: itemId,))
    );
  }

  _yearFilterHandler() {
    if (_searchText.length != 0) {
      _searchHandler();
    }
  }

  _back(BuildContext context) {
    Navigator.pop(context);
  }

  _updateSearchText(String searchText) {
    setState(() {
      _searchText = searchText;
    });
  }

  _scanCode() async {
    await Permission.camera.request();
    String cameraScanResult = await scanner.scan();
    if (cameraScanResult != null) {
      _searchController.text = cameraScanResult;
      _searchText = cameraScanResult;
      _searchHandler();
    } else {
      print('nothing return.');
    }
  }

  @override
  void initState() {
    super.initState();
    _bookDataFetcher = new BookDataFetcher();
    _scrollController.addListener(_fetchNewResult);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _buildBookList(BuildContext context, int index, double screenHeight, double screenWidth) {
    Image _bookImage = Image.network(_resultBookList[index].imageUrl, fit: BoxFit.cover,);

    return Container(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.019),
      child: Row(
        children: [
          // book image
          Hero(
            tag: _resultBookList[index].itemId,
            child: GestureDetector(
              onTap: () => _viewDetails(_resultBookList[index].itemId, _bookImage),
              child: Container(
                width: screenWidth * 0.25,
                height: screenHeight * 0.16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Constants.COLOR_GRAY_BOX_SHADOW,
                      offset: Offset(0.0, 5.0),
                      blurRadius: 5.0,
                      spreadRadius: 1.0
                    )
                  ]
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: _bookImage
                ),
              ),
            ),
          ),

          // book details
          Container(
            width: screenWidth - (screenWidth * 0.4),
            padding: EdgeInsets.only(left: screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _viewDetails(_resultBookList[index].itemId, _bookImage),
                  child: Container(
                    child: Text(
                      _resultBookList[index].bookTitle,
                      style: Constants.TEXT_STYLE_BOOK_LIST_TITLE,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

                // author
                Container(
                  padding: EdgeInsets.only(top: screenHeight * 0.003),
                  child: Text(
                    'by ' + _resultBookList[index].bookAuthor,
                    style: Constants.TEXT_STYLE_BOOK_LIST_SUB_TITLE_1,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // material type, edition, publishing date, availability status
                Container(
                  padding: EdgeInsets.only(top: screenHeight * 0.01),
                  child: Text(
                    _resultBookList[index].collectionName + (_resultBookList[index].edition == "0" ? "" : " (${humanize.ordinal(int.parse(_resultBookList[index].edition))} ed)")  + ", " + _resultBookList[index].publishingYear + " (" + _resultBookList[index].availabilityStatus + ")",
                    style: Constants.TEXT_STYLE_BOOK_LIST_SUB_TITLE_2,
                  ),
                ),

                // library, call number
                Container(
                  padding: EdgeInsets.only(top: screenHeight * 0.0015),
                  child: Text(
                        _resultBookList[index].callNumber == ""
                        ? _resultBookList[index].libraryName + ""
                        : _resultBookList[index].libraryName + ", " + _resultBookList[index].callNumber,
                    style: Constants.TEXT_STYLE_BOOK_LIST_SUB_TITLE_3,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => _back(context),
          child: Icon(
            Icons.arrow_back_outlined,
            color: Constants.COLOR_BLACK,
          ),
        ),
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // search input
            Row(
              children: [
                Expanded(
                  child: CupertinoSearchTextField(
                    padding: EdgeInsets.all(10.0),
                    borderRadius: BorderRadius.circular(7.0),
                    prefixInsets: EdgeInsets.only(left: 12.0),
                    suffixInsets: EdgeInsets.only(right: 12.0),
                    style: Constants.TEXT_STYLE_DROPDOWN_HINT_1,
                    controller: _searchController,
                    onSubmitted: (value) => _searchHandler(),
                    onChanged: (value) => _updateSearchText(value),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(left: screenWidth * 0.02),
                  child: _searchText.length == 0 ?
                  GestureDetector(
                    onTap: () => _scanCode(),
                    child: Icon(
                      Icons.qr_code_scanner_rounded,
                      size: 35
                    ),
                  ) :
                  GestureDetector(
                    onTap: () => _searchHandler(),
                    child: Icon(
                      Icons.search_rounded,
                      size: 35,
                    ),
                  ),
                )
              ],
            ),

            // number of results found
            Container(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
              width: screenWidth,
              child: Text(
                formatter.format(_resultNumber).toUpperCase() + ' result(s) found',
                style: Constants.TEXT_STYLE_SUB_TITLE_1,
                textAlign: TextAlign.left,
              )
            ),

            // filter/sort options
            Row (
              children: [
                Container(
                  width: screenWidth - ((screenWidth * 0.05) * 2) - (screenWidth * 0.11),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        // keyword filter
                        Container(
                          height: 35,
                          width: 87,
                          alignment: AlignmentDirectional.center,
                          padding: EdgeInsets.only(left: 10, right: 3),
                          margin: EdgeInsets.only(
                            right: screenWidth * 0.02,
                            top: screenHeight * 0.0001,
                            bottom: screenHeight * 0.008
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            color: Constants.COLOR_PLATINUM,
                          ),
                          child: PopupMenuButton(
                            itemBuilder: (context) => _keywordList.map<PopupMenuItem<String>>((value) {
                              var part = value.split(',');
                              return PopupMenuItem<String> (
                                value: part[1],
                                child: Text(part[0])
                              );
                            }).toList(),
                            onSelected: (value) => _applyKeywordFilter(value),
                            child: Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    padding: EdgeInsets.only(right: 6),
                                    child: Text(
                                      _selectedKeywordText,
                                      overflow: TextOverflow.ellipsis,
                                      style: Constants.TEXT_STYLE_SEARCH_DROPDOWN
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Constants.COLOR_SONIC_SILVER,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),

                        // material type filter
                        Container(
                          height: 35,
                          width: 99,
                          alignment: AlignmentDirectional.center,
                          padding: EdgeInsets.only(left: 10, right: 3),
                          margin: EdgeInsets.only(
                            right: screenWidth * 0.02,
                            top: screenHeight * 0.0001,
                            bottom: screenHeight * 0.008
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            color: Constants.COLOR_PLATINUM,
                          ),
                          child: PopupMenuButton(
                            itemBuilder: (context) => _materialTypeList.map<PopupMenuItem<String>>((value) {
                              var part = value.split(',');
                              return PopupMenuItem<String> (
                                value: part[1],
                                child: Text(part[0])
                              );
                            }).toList(),
                            onSelected: (value) => _applyMaterialTypeFilter(value),
                            child: Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: 62,
                                    padding: EdgeInsets.only(right: 6),
                                    child: Text(
                                      _selectedCollectionText,
                                      overflow: TextOverflow.ellipsis,
                                      style: Constants.TEXT_STYLE_SEARCH_DROPDOWN
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Constants.COLOR_SONIC_SILVER,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // subject filter
                        Container(
                          height: 35,
                          width: 145,
                          alignment: AlignmentDirectional.center,
                          padding: EdgeInsets.only(left: 10, right: 3),
                          margin: EdgeInsets.only(
                            right: screenWidth * 0.02,
                            top: screenHeight * 0.0001,
                            bottom: screenHeight * 0.008
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            color: Constants.COLOR_PLATINUM,
                          ),
                          child: PopupMenuButton(
                            itemBuilder: (context) => _subjectList.map<PopupMenuItem<String>>((value) {
                              var part = value.split(',');
                              return PopupMenuItem<String> (
                                value: part[1],
                                child: Text(part[0])
                              );
                            }).toList(),
                            onSelected: (value) => _applySubjectFilter(value),
                            child: Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: 108,
                                    padding: EdgeInsets.only(right: 6),
                                    child: Text(
                                      _selectedSubjectText,
                                      overflow: TextOverflow.ellipsis,
                                      style: Constants.TEXT_STYLE_SEARCH_DROPDOWN
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Constants.COLOR_SONIC_SILVER,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Availability
                        Container(
                          height: 35,
                          width: 119,
                          alignment: AlignmentDirectional.center,
                          padding: EdgeInsets.only(left: 10, right: 3),
                          margin: EdgeInsets.only(
                            right: screenWidth * 0.02,
                            top: screenHeight * 0.0001,
                            bottom: screenHeight * 0.008
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            color: Constants.COLOR_PLATINUM,
                          ),
                          child: PopupMenuButton(
                            itemBuilder: (context) => _availabilityList.map<PopupMenuItem<String>>((value) {
                              var part = value.split(',');
                              return PopupMenuItem<String> (
                                value: part[1],
                                child: Text(part[0])
                              );
                            }).toList(),
                            onSelected: (value) => _applyAvailabilityFilter(value),
                            child: Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: 82,
                                    padding: EdgeInsets.only(right: 6),
                                    child: Text(
                                      _selectedAvailabilityText,
                                      overflow: TextOverflow.ellipsis,
                                      style: Constants.TEXT_STYLE_SEARCH_DROPDOWN
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Constants.COLOR_SONIC_SILVER,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // sorting options
                Container(
                  width: screenWidth * 0.11,
                  height: 35,
                  margin: EdgeInsets.only(bottom: screenHeight * 0.008),
                  padding: EdgeInsets.only(left: screenWidth * 0.02),
                  child: PopupMenuButton(
                    onSelected: (option) => _applySortingOption(option),
                    itemBuilder: (context) => _sortOptionList.map<PopupMenuEntry>((element) {
                      if (element == "-") {
                        return PopupMenuDivider(height: 1.0);
                      }
                      var part = element.split(',');
                      return CheckedPopupMenuItem<String> (
                        checked: _sortingOption == part[1] ? true : false,
                        value: part[1],
                        child: Text(part[0])
                      );
                    }).toList(),
                    child: Icon(
                      Icons.sort_rounded,
                      size: 35,
                    ),
                  )
                )
              ],
            ),

            Container(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
              child: Row(
                children: [
                  Container(
                    child: Text(
                      'From',
                      style: Constants.TEXT_STYLE_SEARCH_DROPDOWN
                    ),
                  ),

                  Container(
                    height: 35,
                    width: 60,
                    margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.0),
                      color: Constants.COLOR_PLATINUM,
                    ),
                    child: TextField(
                      controller: _startingYearController,
                      keyboardType: TextInputType.number,
                      onSubmitted: (year) => _yearFilterHandler(),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 11.0, left: 10.0, right: 10.0),
                        border: InputBorder.none
                      ),
                    )
                  ),

                  Container(
                    child: Text(
                      'To',
                      style: Constants.TEXT_STYLE_SEARCH_DROPDOWN
                    ),
                  ),

                  Container(
                    height: 35,
                    width: 60,
                    margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.0),
                      color: Constants.COLOR_PLATINUM,
                    ),
                    child: TextField(
                      controller: _endingYearController,
                      keyboardType: TextInputType.number,
                      onSubmitted: (year) => _yearFilterHandler(),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 11.0, left: 10.0, right: 10.0),
                        border: InputBorder.none
                      ),
                    )
                  ),
                ],
              ),
            ),

            // book list
            // Expanded(
            //   child: ListView.builder(
            //     controller: _scrollController,
            //     physics: BouncingScrollPhysics(),
            //     itemCount: _resultBookList.length,
            //     itemBuilder: (BuildContext context, int index) =>
            //         _buildBookList(context, index, screenHeight, screenWidth),
            //   ),
            // ),

            Expanded(
              child: _searchState == SearchState.Idle
                  ? Container()
                  : _searchState == SearchState.Searching
                  ? Container(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: screenHeight * 0.29,
                      child: SmartFlareActor(
                        filename: 'assets/walk_searching.flr',
                        height: screenHeight * 0.3,
                        startingAnimation: "walking",
                        playStartingAnimationWhenRebuilt: false,
                      ),
                    )
                  )
                  : _searchState == SearchState.NotFound
                  ? Container(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: screenHeight * 0.29,
                      child: SmartFlareActor(
                        filename: 'assets/not_found.flr',
                        height: screenHeight * 0.35,
                        startingAnimation: "not_found",
                        playStartingAnimationWhenRebuilt: false,
                      ),
                    ),
                  )
                  : ListView.builder(
                    controller: _scrollController,
                    physics: BouncingScrollPhysics(),
                    itemCount: _resultBookList.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (_resultBookList.length < _resultNumber && (index + 1) == _resultBookList.length && _isLoading) {
                        return SpinKitThreeBounce(
                          color: Constants.COLOR_BLUE_THEME,
                          size: 30,
                          duration: Duration(milliseconds: 800),
                        );
                      }
                      return _buildBookList(context, index, screenHeight, screenWidth);
                    }
                    // itemBuilder: (BuildContext context, int index) =>
                    // _resultBookList.length < _resultNumber
                    //     ? _buildBookList(context, index, screenHeight, screenWidth)
                    //     : SpinKitThreeBounce(color: Constants.COLOR_BLUE_THEME,)
                  )
            ),

          ],
        ),
      ),
    );
  }

}