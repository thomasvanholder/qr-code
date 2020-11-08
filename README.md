Rails app generated with [lewagon/rails-templates](https://github.com/lewagon/rails-templates), created by the [Le Wagon coding bootcamp](https://www.lewagon.com) team.

#### Create Pull Request
```
ISSUE_NAME="123 Fixed A Bug"
BRANCH_NAME=$(echo $ISSUE_NAME | tr '[:upper:]' '[:lower:]' | tr '/' '-' | tr ' ' '-')
git checkout -b $BRANCH_NAME
git add .
git add -u
git commit -m "Fixed a bug for #123"
git push -u origin $BRANCH_NAME
```

#### Create Release Tag
```
TAG_NAME=`date "+%Y-%m-%d_%H-%M-%S"`
git tag -a $TAG_NAME -m $TAG_NAME
git push origin --tags
```
