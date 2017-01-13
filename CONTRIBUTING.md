# Contributing

Comments and pull requests to this project are welcome.

## General repository structure

All mission files in the directory _missions_ are generated automatically via
scripting tasks in the [_Rakefile_][rf]. Therefore if you would like to contribute,
make sure you apply your changes to the files in the _src_ directory.
Don't forget to regenerate the mission files once you are done!

## Build tasks

This project uses the ruby build utility called [rake][rk].

[rk]:https://ruby.github.io/rake/

All build tasks are contained in the [Rakefile][rf] of this project.

[rf]:https://github.com/kikito/lua_missions/blob/master/Rakefile

## How to contribute a pull request

1. Fork the [lua_missions][lm] repository first, then clone it:

    git clone git@github.com:your-username/lua_missions.git

2. Apply your changes to the files in the _src_ directory.

3. Make sure you can execute all missions without errors or failures:

    rake missions:run_src

4. Regenerate the mission files:

    rake missions:gen

5. Commit your changes to your repository. You may use the corresponding _rake_ task for that. If you added new files, don't forget to _git add_ them prior to your commit.

    rake git:commit -m='your commit message'

6. Push to your fork. Again, you may use the corresponding _rake_ task for that.

    rake git:push

7. Submit a [pull request][pr].

[lm]:[https://github.com/kikito/lua_missions
[pr]: https://github.com/kikito/lua_missions/compare

At this point you have to wait for me. I try to at least comment on
pull requests within a few days. Be prepared that I may suggest some
improvements and/or propose changes or alternatives.

## Mission solving

With the rake infrastructure in place, you may start solving the missions right away:

    rake missions:run

Since _missions:run_ is the default _rake_ task, you may start mission solving by simply typing:

    rake
