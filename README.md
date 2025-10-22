Before you do anything, run
```
git submodule update --init --recursive
```

To compile, run
```
./patcher p
```
to apply patches and
```
./patcher b
```
to build it via gradle or maven.

For making changes, you need to make changes in the PatchedFork-Patched folder, commit them and run
```
./patcher rb
```
to rebuild the patches. Then commit the patches in the main folder. NEVER commit the PatchedFork-Patched folder!

If you're creating a new fork then edit UPSTREAM_NAME, FORK_NAME & REPO in init.sh. Also if you want to use the updateUpstream script to generate a commit with all the changes, make sure your gitmodule doesn't end with .git in .gitmodules
