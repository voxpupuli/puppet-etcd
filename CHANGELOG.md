# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v2.1.0](https://github.com/voxpupuli/puppet-etcd/tree/v2.1.0) (2025-12-01)

[Full Changelog](https://github.com/voxpupuli/puppet-etcd/compare/v2.0.0...v2.1.0)

**Implemented enhancements:**

- Add EL10 support [\#39](https://github.com/voxpupuli/puppet-etcd/pull/39) ([bastelfreak](https://github.com/bastelfreak))
- Add Debian 13 support [\#38](https://github.com/voxpupuli/puppet-etcd/pull/38) ([bastelfreak](https://github.com/bastelfreak))

## [v2.0.0](https://github.com/voxpupuli/puppet-etcd/tree/v2.0.0) (2025-10-20)

[Full Changelog](https://github.com/voxpupuli/puppet-etcd/compare/v1.2.0...v2.0.0)

**Breaking changes:**

- Drop puppet, update openvox minimum version to 8.19 [\#31](https://github.com/voxpupuli/puppet-etcd/pull/31) ([TheMeier](https://github.com/TheMeier))

**Implemented enhancements:**

- Allow puppet-systemd 9.x [\#36](https://github.com/voxpupuli/puppet-etcd/pull/36) ([TheMeier](https://github.com/TheMeier))
- puppet/archive Allow 8.x [\#30](https://github.com/voxpupuli/puppet-etcd/pull/30) ([TheMeier](https://github.com/TheMeier))
- metadata.json: Add OpenVox [\#26](https://github.com/voxpupuli/puppet-etcd/pull/26) ([jstraw](https://github.com/jstraw))

**Closed issues:**

- Migrate module to Vox Pupuli [\#17](https://github.com/voxpupuli/puppet-etcd/issues/17)

## [v1.2.0](https://github.com/voxpupuli/puppet-etcd/tree/v1.2.0) (2025-02-26)

[Full Changelog](https://github.com/voxpupuli/puppet-etcd/compare/v1.1.0...v1.2.0)

**Implemented enhancements:**

- Add OracleLinux/CentOS/AlmaLinux support [\#22](https://github.com/voxpupuli/puppet-etcd/pull/22) ([bastelfreak](https://github.com/bastelfreak))
- Add Debian 12 & Ubuntu 24.04 support [\#21](https://github.com/voxpupuli/puppet-etcd/pull/21) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- metadata.json & README.md: Adjust for migration to Vox Pupuli [\#20](https://github.com/voxpupuli/puppet-etcd/pull/20) ([bastelfreak](https://github.com/bastelfreak))
- Drop Puppet \< 6.1.0 compatibility code [\#19](https://github.com/voxpupuli/puppet-etcd/pull/19) ([bastelfreak](https://github.com/bastelfreak))

## [v1.1.0](https://github.com/tailored-automation/puppet-module-etcd/tree/v1.1.0) (2025-02-19)

[Full Changelog](https://github.com/tailored-automation/puppet-module-etcd/compare/v1.0.0...v1.1.0)

### Added

- update to\_yaml\(\)-\>stdlib::to\_yaml\(\) [\#16](https://github.com/tailored-automation/puppet-module-etcd/pull/16) ([bastelfreak](https://github.com/bastelfreak))
- puppet/systemd: Allow 7.x & 8.x [\#15](https://github.com/tailored-automation/puppet-module-etcd/pull/15) ([bastelfreak](https://github.com/bastelfreak))

### Merged pull requests:

- Add documentation on how to configure SSL [\#13](https://github.com/tailored-automation/puppet-module-etcd/pull/13) ([treydock](https://github.com/treydock))
- Test stdlib 9.x with regular unit tests [\#12](https://github.com/tailored-automation/puppet-module-etcd/pull/12) ([treydock](https://github.com/treydock))

## [v1.0.0](https://github.com/tailored-automation/puppet-module-etcd/tree/v1.0.0) (2023-11-15)

[Full Changelog](https://github.com/tailored-automation/puppet-module-etcd/compare/v0.4.0...v1.0.0)

### Changed

- Numerous updates [\#11](https://github.com/tailored-automation/puppet-module-etcd/pull/11) ([treydock](https://github.com/treydock))

## [v0.4.0](https://github.com/tailored-automation/puppet-module-etcd/tree/v0.4.0) (2021-06-19)

[Full Changelog](https://github.com/tailored-automation/puppet-module-etcd/compare/v0.3.0...v0.4.0)

### Added

- Add Puppet 7 and use Github Actions [\#9](https://github.com/tailored-automation/puppet-module-etcd/pull/9) ([treydock](https://github.com/treydock))

## [v0.3.0](https://github.com/tailored-automation/puppet-module-etcd/tree/v0.3.0) (2020-07-20)

[Full Changelog](https://github.com/tailored-automation/puppet-module-etcd/compare/v0.2.0...v0.3.0)

### Merged pull requests:

- Use https consistently for installing module dependencies [\#8](https://github.com/tailored-automation/puppet-module-etcd/pull/8) ([ghoneycutt](https://github.com/ghoneycutt))
- wal-dir needs to be a directory in which the etcd user can write [\#7](https://github.com/tailored-automation/puppet-module-etcd/pull/7) ([ghoneycutt](https://github.com/ghoneycutt))

## [v0.2.0](https://github.com/tailored-automation/puppet-module-etcd/tree/v0.2.0) (2020-05-13)

[Full Changelog](https://github.com/tailored-automation/puppet-module-etcd/compare/22116ccd519d55d1cb653d1d84d281d250e5046c...v0.2.0)

### Added

- Add logic to manage etcd [\#1](https://github.com/tailored-automation/puppet-module-etcd/pull/1) ([treydock](https://github.com/treydock))

### Merged pull requests:

- Fix release process and add missing data to metadata.json [\#4](https://github.com/tailored-automation/puppet-module-etcd/pull/4) ([treydock](https://github.com/treydock))
- Setup deployment to forge on tag [\#3](https://github.com/tailored-automation/puppet-module-etcd/pull/3) ([treydock](https://github.com/treydock))
- Add basic travis config [\#2](https://github.com/tailored-automation/puppet-module-etcd/pull/2) ([treydock](https://github.com/treydock))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
