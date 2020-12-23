# SelfTableViewManager

Um jeito simples de criar e manipular uma UITableView.

[![CI Status](http://img.shields.io/travis/jjfernandes87/SelfTableViewManager.svg?style=flat)](https://travis-ci.org/jjfernandes87/SelfTableViewManager)
[![Version](https://img.shields.io/cocoapods/v/SelfTableViewManager.svg?style=flat)](http://cocoapods.org/pods/SelfTableViewManager)
[![License](https://img.shields.io/cocoapods/l/SelfTableViewManager.svg?style=flat)](http://cocoapods.org/pods/SelfTableViewManager)
[![Platform](https://img.shields.io/cocoapods/p/SelfTableViewManager.svg?style=flat)](http://cocoapods.org/pods/SelfTableViewManager)

## Features

- [x] Carregue uma coleção de UITableViewCell passando apenas um array
- [x] Carregue UITableViewCell com xib, sem necessidade de implementar Register(nib)
- [x] Remova UITableViewCell com apenas uma linha

## Requirements

- iOS 9.3+
- Xcode 9.0+
- Swift 5.0+

## Communication

- Se você **encontrou um bug**, abra uma issue.
- Se você **tem uma nova feature**, abra uma issue.
- Se você **quer contribuir**, envie uma pull request.

## Example

Para rodar o projeto de exemplo, clone o repositório, e rode o comando `pod install` no diretório Example primeiro.

## Installation

SelfTableViewManager esta disponível através [CocoaPods](http://cocoapods.org). Para instalar, basta adicionar a linha abaixo no seu Podfile:

```ruby
pod 'SelfTableViewManager'
```
Criando uma CellController e CellView. Veja que é necessário você adicionar @objc para sua classe que extende CellController, precisamos disso porque nossa CollectionManager usa o nome da classe como cellIdentifier (você deve configurar sua UITableViewCell com o mesmo nome da sua CellController no seu Xib ou Storyboard)

```swift
import SelfTableViewManager

@objc(CustomCell)
class CustomCell: CellController {
...
}

class CustomCellView: CellView {
...
}
```
Depois de criada sua classe CellController está na hora de implementar os métodos necessários para seu funcionamento.

```swift
import SelfTableViewManager

@objc(CustomCell)
class CustomCell: CellController {
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        ...
    }
}
```
Na sua classe CellView vamos expor nossos IBOutlets.

```swift

class CustomCellView: CellView {
    @IBOutlet weak var ...
}
```
Agora falta pouco!
Precisamos popular nossa Interface com as cell's que acabamos de construir.

```swift
import CollectionManager

class ViewController: UIViewController {

    @IBOutlet weak var tableView: SelfTableViewManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rows = [CustomCell(),CustomCell(),CustomCell(),CustomCell(),CustomCell(),CustomCell()]
    }
}
```

Pronto!

## Author

jjfernandes87, julio.fernandes87@gmail.com

## License

SelfTableViewManager is available under the MIT license. See the LICENSE file for more info.
