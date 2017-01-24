# RxSwiftTableViewExample1
This is a slightly modified version of the CitySearch app from the tutorial: 
http://www.thedroidsonroids.com/blog/ios/rxswift-by-examples-1-the-basics/

What has changed from the demo app shown in the tutorial:

* I have made shownCities as of **Variable** type so that we can use it as observable.
* I have binded the tableView to the shownCities variable instead of using dataSource for the tableView.
* Have used **UISearchController** instead of UISearchBar.
* Have handled the cancel of searchBar using rx methods.
