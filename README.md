[github-sync]: https://github.com/repo-sync/github-sync
[wiki-creator]: https://github.com/Decathlon/wiki-page-creator-action
[pat]: https://github.com/settings/tokens/new?scopes=repo&description=repository-sync%20token

> # Archived
> This repo has been archived as it is fairly difficult to achieve what this Action is supposed to do.

## GitHub Repository Sync
This action allows you to push changes made on one repo, to be pushed to another.

It was inspired by [repo-sync/github-sync][github-sync] and [Decathlon/wiki-page-creator-action][wiki-creator] but contains changes compared to both of them, like allowing to only push content from a specific folder to a specific folder on the target repository.

## Setting it up
Before setting this action up, make sure you did the following steps.
- Create a [Personal Access Token][pat] with the `repo` scope checked. Click the link to get to the page or navigate to it by going to `Settings -> Developer settings -> Personal access tokens`
- Copy the PAT
- Go to your source repo, where you setup the file and add the PAT as a new secret. You can name it whatever you want.

**Recommended**:  
If you want to keep your E-Mail save, create a separate secret containing your GitHub e-mail.

After this is done can we now setup this action on your repository.

### workflow file
Create a new YAML file in `.github/workflows` (Or go to `Actions (-> New workflow (if you already have one)) -> Set up a workflow yourself`) and put the following content into it.

```yaml
name: Sync Repository

on: [push]

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1
    - name: Sync Repository
      uses: Andre601/repository-sync
      env:
        PAT: ${{ secrets.PAT }}
        EMAIL: ${{ secrets.EMAIL }}
        USER: MyName
        OWNER: MyName
        REPO: TargetRepo
```

#### Required ENV variables

- `PAT`  
The Personal Access Token to use.
- `EMAIL`  
The E-Mail address to use.
- `USER`  
The Username to use.
- `OWNER`  
Name of the user or organisation of the target repository.
- `REPO`  
Name of the target repository.

#### Optional ENV variables

- `SRC_FOLDER`  
Folder to pull the files from. Defaults to `.` (Entire source repository)
- `TARGET_FOLDER`  
Folder to push the files to. Defaults to `.` (Root directory of the target repository)
- `EXCLUDE`  
Comma-separated String of file-names that should be excluded from the push. Defaults to no exclusion.
- `PUSH_MESSAGE`  
Message to use as the commit-message. Defaults to `Syncing repositories`

### Complete example
Here is a complete example of all options being used.

```yaml
name: Sync Repository

on: [push]

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1
    - name: Sync Repository
      uses: Andre601/repository-sync
      env:
        PAT: ${{ secrets.PAT }}
        EMAIL: ${{ secrets.EMAIL }}
        USER: MyName
        OWNER: MyName
        REPO: TargetRepo
        SRC_FOLDER: cat-images
        TARGET_FOLDER: images/cat-images
        EXCLUDE: 'README.md'
        PUSH_MESSAGE: 'Saving the cute cat images'
```
