# Code Review

> This is very simple Bash & Python scripting which can be used to speed up code reviews. 
> It is very useful for reviewing code in a bigger teams while the amount of code to review is huge.
> Do not expect spectacular results, but it can help you to save some time.

## How does it work?

> Script is looking at the diff of your changes and then it is using OpenAI API to generate a summary of the changes, suggestions, and improvements.
> Each file is processed separately and the results are saved in separate files each.

## How to use it?

Make sure to set your OpenAI API key as an environment variable so it can be consumed by the script.

```bash
$ export OPENAI_API_KEY=<your_openai_api_key>
```

```bash
$ ./code_review.sh origin/main origin/my_feature_branch
```

## Limitations?

> Script is assuming that your remote git repo is called `origin`.

## Thanks

* Thanks to [OpenAI](https://openai.com/) for providing such a great API.
* Thanks to [Git](https://git-scm.com/) for providing such a great tool.
* Thanks to [Bash](https://www.gnu.org/software/bash/) for providing such a great scripting language.
* Thanks to [Python](https://www.python.org/) for providing such a great scripting language.

Best regards,
Michal :)