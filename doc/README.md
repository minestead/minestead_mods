# Help
The goal of this modpack is to make using Minetest and mods easier for both
newcomers and advanced users.
It makes it easier for newcomers by making help more accessible.
It makes life easier for advanced user by making it more convenient to use, by
centralizing the help where you most need it: Inside the game. This modpack
will also make the life of modder easier by allowing them to add help texts
directly into mods (via `doc_items`).

For Minetest 5.0.0 or later.

More information is given in the respective mods.

Overview of the mods:

* `doc`: Documentation System. Core API and user interface. Mods can add arbitrary categories and entries
* `doc_basics`: Basic Help. Adds basic help texts about Minetest, controls, gameplay and other basics
* `doc_items`: Item Help. Adds automatically generated help texts for items and an API
* `doc_encyclopedia`: Encyclopedia. An item to access the help
* `doc_identifier`: Lookup Tool. A tool to identify and show help texts for pointed things

## How to clone (Information for developers)

This repository does not directly include the mods,
but as [https://git-scm.com/book/en/v2/Git-Tools-Submodules](Git submodules) instead.

You can use the following command to clone this repository and get all its submodules:

    git clone http://repo.or.cz/minetest_doc_modpack.git --recurse-submodules

Consult the Git help to learn more about working with submodules.
