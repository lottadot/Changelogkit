## ChangelogKit

### Description

This is a macOS Swift Framework for simple change log analysis. It is used by [JiraTools](https://github.com/lottadot/jiratools) and and [ChangelogParser](https://github.com/lottadot/ChangelogParser).

### Install

Use Carthage to install.

#### Changelog Format

```
1.0{.0} #999 YYYY-mm-dd
=============
- Comment
- TicketIdentifier Human Description of the ticket
```

For a build that's not releasing yet, the date has 'TBD' in it:

```
1.0.1 #100 2016-TBD
=============
- Comment
* TicketIdentifier Human Description of the ticket
* IssueId3 This is a Ticket Issue3

1.0.1 #999 2016-08-22
=============
- Comment like Please logout and uninstall any existing builds
- Some comment like this points to Production
* TicketIdentifier Human Description of the ticket
* IssueId2 This is a Ticket Issue2
* IssueId1 This is a Ticket Issue1
```

