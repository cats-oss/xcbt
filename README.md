# xcbt

Show Xcode build time of project.

## Installation

Clone this repository and run `install.sh`

```
$ git clone https://github.com/cats-oss/xcbt.git
$ cd xcbt
$ ./install.sh
```

## Usage

#### 1. Show build time of specified App

```
$ xcbt cujira
Scheme: cujira-Package

    - Build start : 2018-10-02 12:52:04 +0000
    - Build end   : 2018-10-02 12:52:13 +0000
    - Build time  : 9.6459s
```

#### 2. Show build time of specified path

```
$ xcbt --path "~/Library/Developer/Xcode/DerivedData/cujira-gmnfnyurvxsymsaolrsdojmyukyk"
Scheme: cujira-Package

    - Build start : 2018-10-02 12:52:04 +0000
    - Build end   : 2018-10-02 12:52:13 +0000
    - Build time  : 9.6459s
```

#### 3. Show build time of last built

```
$ xcbt --last
Scheme: cujira-Package

    - Build start : 2018-10-02 12:52:04 +0000
    - Build end   : 2018-10-02 12:52:13 +0000
    - Build time  : 9.6459s
```

## Development

- Xcode 9.4.1
- Swift 4.1

## License

xcbt is available under the MIT license. See the [LICENSE file](./LICENSE) for more info.
