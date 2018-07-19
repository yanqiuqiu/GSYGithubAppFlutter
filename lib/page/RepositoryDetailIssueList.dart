import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gsy_github_app_flutter/common/config/Config.dart';
import 'package:gsy_github_app_flutter/common/dao/IssueDao.dart';
import 'package:gsy_github_app_flutter/common/style/GSYStyle.dart';
import 'package:gsy_github_app_flutter/widget/GSYCardItem.dart';
import 'package:gsy_github_app_flutter/widget/GSYPullLoadWidget.dart';
import 'package:gsy_github_app_flutter/widget/IssueItem.dart';

/**
 * 仓库详情issue列表
 * Created by guoshuyu
 * Date: 2018-07-19
 */
class RepositoryDetailIssuePage extends StatefulWidget {
  final String userName;

  final String reposName;

  RepositoryDetailIssuePage(this.userName, this.reposName);

  @override
  _RepositoryDetailIssuePageState createState() => _RepositoryDetailIssuePageState(userName, reposName);
}

// ignore: mixin_inherits_from_not_object
class _RepositoryDetailIssuePageState extends State<RepositoryDetailIssuePage> with AutomaticKeepAliveClientMixin {
  final String userName;

  final String reposName;

  String issueState;

  bool isLoading = false;

  int page = 1;

  final List dataList = new List();

  final GSYPullLoadWidgetControl pullLoadWidgetControl = new GSYPullLoadWidgetControl();

  _RepositoryDetailIssuePageState(this.userName, this.reposName);

  Future<Null> _handleRefresh() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page = 1;
    var res = await IssueDao.getRepositoryIssueDao(userName, reposName, issueState, page: page);
    if (res != null && res.result) {
      pullLoadWidgetControl.dataList.clear();
      setState(() {
        pullLoadWidgetControl.dataList.addAll(res.data);
      });
    }
    setState(() {
      pullLoadWidgetControl.needLoadMore = (res != null && res.data != null && res.data.length == Config.PAGE_SIZE);
    });
    isLoading = false;
    return null;
  }

  Future<Null> _onLoadMore() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page++;
    var res = await IssueDao.getRepositoryIssueDao(userName, reposName, issueState, page: page);
    if (res != null && res.result) {
      setState(() {
        pullLoadWidgetControl.dataList.addAll(res.data);
      });
    }
    setState(() {
      pullLoadWidgetControl.needLoadMore = (res != null && res.data != null && res.data.length == Config.PAGE_SIZE);
    });
    isLoading = false;
    return null;
  }

  _renderEventItem(index) {
    IssueItemViewModel issueItemViewModel = pullLoadWidgetControl.dataList[index];
    return new IssueItem(
      issueItemViewModel,
      onPressed: () {},
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    pullLoadWidgetControl.needHeader = false;
    pullLoadWidgetControl.dataList = dataList;
    if (pullLoadWidgetControl.dataList.length == 0) {
      _handleRefresh();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        leading: new Column(
          children: <Widget>[
            new Container(
              child: new TextField(
                  autofocus: true,
                  decoration: new InputDecoration.collapsed(
                    hintText: GSYStrings.repos_issue_search,
                    hintStyle: GSYConstant.subSmallText,
                  ),
                  style: GSYConstant.smallText,
                  onSubmitted: (result) {}),
            ),
            new GSYCardItem(
                color: Color(GSYColors.primaryValue),
                margin: EdgeInsets.all(10.0),
                shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                child: new Padding(
                    padding: new EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0, bottom: 5.0),
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                            child: new Text(
                          "Ffff",
                          style: GSYConstant.middleTextWhite,
                        )),
                        new Container(width: 0.3, height: 40.0, color: Color(GSYColors.subLightTextColor)),
                        new Expanded(
                            child: new Text(
                          "Ffff",
                          style: GSYConstant.middleTextWhite,
                        )),
                        new Container(width: 0.3, height: 40.0, color: Color(GSYColors.subLightTextColor)),
                        new Expanded(
                            child: new Text(
                          "Ffff",
                          style: GSYConstant.middleTextWhite,
                        )),
                      ],
                    )))
          ],
        ),
      ),
      body: GSYPullLoadWidget(pullLoadWidgetControl, (BuildContext context, int index) => _renderEventItem(index), _handleRefresh, _onLoadMore),
    );
  }
}