# SGA Shopify Challange

This repository serves the purpose of getting done with some challenges on the shopify store development. It completes some technical questions which I would be solving.

## Locating the theme

Since it is required by the linter specifications at [shopify/theme-check](https://github.com/Shopify/theme-check), the files for actual Shopify store theme are located under `test/theme/..` folder

## Supported Checks

Theme Check currently checks for the following:

✅ Liquid syntax errors  
✅ JSON syntax errors  
✅ Missing snippet & section templates  
✅ Unused `{% assign ... %}`  
✅ Unused snippet templates  
✅ Template length  
✅ Deprecated tags  
✅ Unknown tags  
✅ Unknown filters  
✅ Missing `{{ content_for_* }}` in `theme.liquid`  
✅ Excessive nesting of snippets  
✅ Missing or extra spaces inside `{% ... %}` and `{{ ... }}`  
✅ Missing default locale file  
✅ Unmatching translation keys in locale files  
✅ Using unknown translation keys in `{{ 'missing_key' | t }}`  
✅ Using several `{% ... %}` instead of `{% liquid ... %}`  
✅ Undefined [objects](https://shopify.dev/docs/themes/liquid/reference/objects)  
✅ Deprecated filters  
✅ Missing `theme-check-enable` comment

As well as checks that prevent easy to spot performance problems:

✅ Use of [parser-blocking](/docs/checks/parser_blocking_javascript.md) JavaScript  
✅ [Use of non-Shopify domains for assets](/docs/checks/remote_asset.md)  
✅ [Missing width and height attributes on `img` tags](/docs/checks/img_width_and_height.md)  
✅ [Too much JavaScript](/docs/checks/asset_size_javascript.md)  
✅ [Too much CSS](/docs/checks/asset_size_css.md)

## Technologies Used

- Ruby, Liquid (Templating language for Shopify)

## Authors

👤 **Uzair**

- LinkedIn: [LinkedIn](https://www.linkedin.com/in/uzair-ali-964187166/)
- GitHub: [GithubHandle](https://github.com/uzairali19)

## Getting Started

### Setup Local

To get a local copy of this project follow the steps below:

Use `git clone https://github.com/uzairali19/sga-shopify-tasks` to clone the branch directly to your machine

### Testing template with theme-check

To test the Shopify theme template, Open terminal inside your editor or on your system:

1. Navigate to the folder `sga-shopify-tasks`
2. Run `bundle install`
3. Run `cd test/theme`
4. Run `theme-check` to test the template directories

### To test the ruby files containing tests [rubocop](https://docs.rubocop.org/en/stable/)

1. Navigate to root folder `sga-shopify-tasks`
2. Run `rubocop`.
3. Fix linter errors.
4. **IMPORTANT NOTE**: feel free to research [auto-correct options for Rubocop](https://rubocop.readthedocs.io/en/latest/auto_correct/) if you get a flood of errors but keep in mind that correcting style errors manually will help you to make a habit of writing a clean code!

- Happy coding!

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

Feel free to check the [issues page](https://github.com/uzairali19/sga-shopify-tasks/issues).

## Show your support

Give a ⭐️ if you like this project!

## 📝 License

This project is copyright protected, Feel free to contact the authors to collaborate.
