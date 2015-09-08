onddo_proftpd CHANGELOG
=======================

This file is used to list changes made in each version of the `onddo_proftpd` cookbook.

## v2.1.0 (2015-09-08)

* Fix Ubuntu `15.04` support.
* Improve platforms support using `node['platform_family']` node attribute.
* Update chef links to use *chef.io* domain.
* Update contact information and links after migration.
* metadata: Add `source_url` and `issues_url` links.

* Documentation:
 * README: Add GitHub badge.

* Testing:
 * Some test files updated: .travis.yml, Berksfile, Gemfile, Rakefile.
 * Gemfile: Update RuboCop to `0.34.0`.
 * Move ChefSpec tests to *test/unit*.
 * Replace all bats tests by Serverspec tests.
 * Add *.kitchen.docker.yml* file for `kitchen-docker`.
 * Run kitchen on Travis using `kitchen-in-travis` script.

## 2.0.0 (2014-10-24)

* **Update Warning**: Ruby `<= 1.9.2` compatibilty drop. Ruby `>= 1.9.3` is **required**.
* Create an empty *modules.conf* file to fix Debian updates (fixes [issue #5](https://github.com/zuazo/proftpd-cookbook/issues/5), thanks [Denny Schäfer](https://github.com/tuxinaut) for reporting).
* Fix all RuboCop offenses (big libraries refactor).
* Update to use Serverspec `2`.
* Update to use ChefSpec `4.1`.
* Integrate tests with `should_not` gem.
* `.kitchen.yml`: use one line array to include apt in the Run List.
* Use a more complete `Berksfile` template.
* `Rakefile`: add documentation link.
* Add `Guardfile`.
* Homogenize license headers.
* `README`:
 * Add a missing dot in a recipe description.
 * Use single quotes in examples.
 * Use markdown tables.
 * Add Code Climate badge.

## 1.0.0 (2014-09-28)

* **Update Warning**: [Disabled some modules by default](https://github.com/zuazo/proftpd-cookbook/commit/9ba698f99b27348084cba7cd10c460edbca0484a) to fix Ubuntu 10 compatibility: *exec*, *shaper*, *sftp* and *sftp_pam*.
* **Update Warning**: [Set *DefaultAddress* configuration option](https://github.com/zuazo/proftpd-cookbook/blob/ccc7f116b38581a2b6637600bd864feaa27da639/attributes/conf.rb#L1) to avoid some start errors (related with [issue #2](https://github.com/zuazo/proftpd-cookbook/issues/2), thanks [@fervic](https://github.com/fervic) for reporting).
* Fixed integration tests for CentOS 5.
* Fix Ubuntu 14.04 support (monkey-patch for [bug 1293416](https://bugs.launchpad.net/ubuntu/+source/proftpd-dfsg/+bug/1293416), fixes [issue #2](https://github.com/zuazo/proftpd-cookbook/issues/2), thanks [@themasterchef](https://github.com/themasterchef) for reporting).
* Fix FC034: Unused template variables.
* `kitchen.yml`: Added more platforms to test.
* `kitchen.cloud.yml`: removed yum from run list.
* `Gemfile` updated and improved using groups.
* `Berksfile` cleaned and updated to Berkshelf 3.
* Added some basic Serverspec tests.
* Added ChefSpec tests and a `Rakefile`.
* *test/kitchen/cookbooks* directory moved to *test/cookbooks*.
* Added `LICENSE` file.
* Added `travis.yml` file.
* `README`:
 * Added badges: cookbook version, gemnasium and travis-ci.
 * Updated cookbook links to point to Supermarket.
 * Separated into multiple files.
 * Some small improvements.
* Added RedHat as supported platform.
* Some integration tests fixes to support more platforms.
* Integration tests improved: added `onddo_proftpd_test::attrs` recipe.
* Added a `Vagrantfile` and its documentation.

## 0.1.0 (2014-04-25)

* Initial release of `onddo_proftpd`.
