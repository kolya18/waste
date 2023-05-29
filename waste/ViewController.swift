//
//  ViewController.swift
//  waste
//
//  Created by Николай Мартынов on 11.04.2023.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var classificationLabel: UILabel!

    let imagePicker = UIImagePickerController()
    var model: VNCoreMLModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Загрузка модели Core ML
        model = try! VNCoreMLModel(for: WasteImageClassifier_a().model)
        imagePicker.delegate = self
    }

    @IBAction func chooseImage(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func takePhoto(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        // Получаем выбранное изображение
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        imageView.image = image
        // Выполняем классификацию
        classifyImage(image: image)
    }
    
//    Предсказание отхода перевод
    func convertString(inputString: String) -> String {
        let replacements = [
            "XLight": "Ренгеновский_снимок",
            "watermelonrind": "Очистки_фруктов_или_овощей",
            "traditionalChinesemedicine": "Традиционная_китайская_медицина",
            "toothpick": "Зубочистки",
            "toothpastetube": "Тюбик_зубной_пасты",
            "toothbrush": "Зубная_щетка",
            "thermometer": "Ртутный_термометр",
            "tabletcapsule": "Таблетки",
            "rag": "Тряпка",
            "plasticene": "Пластелин",
            "plasticbottle": "Пластиковая_бутылка",
            "plasticbag": "Пластиковый_пакет",
            "pesticidebottle": "Бутылка_с_химическими_веществами",
            "penholder": "Пенал",
            "nut": "Орехи",
            "newspaper": "Газеты",
            "napkin": "Салфетки",
            "nailpolishbottle": "Лак_для_ногтей",
            "milkbox": "Пакет_молока",
            "medicinebottle": "Емкость_для_лекарств",
            "leftovers": "Объедки",
            "leaflet": "Журнальные_листовки",
            "glassbottle": "Стеклянная_бутылка",
            "facialmask": "Маска_для_лица",
            "diapers": "Подгузники",
            "cigarettebutt": "Окурок",
            "chopsticks": "Деревянные_палочки",
            "carton": "Картон",
            "cans": "Жестяные_банки",
            "bulb": "Лампочки",
            "bread": "Хлеб",
            "bowlsanddishes": "Посуда",
            "battery": "Батарейки",
            "bandaid": "Лейкопластырь"
        ]
        
        var outputString = inputString
        
        for (key, value) in replacements {
            outputString = outputString.replacingOccurrences(of: key, with: value)
        }
        
        return outputString
    }
    
    
//    Рекомендации по утилизации
    func descriptionString(inputString: String) -> String {
        let replacements = [
            "XLight": "Ренгеновский_снимок (сдать в медучреждение для утилизации)",
            "watermelonrind": "Очистки_фруктов_или_овощей (можно использовать в компосте)",
            "traditionalChinesemedicine": "Традиционная_китайская_медицина (сдать в аптеку для утилизации)",
            "toothpick": "Зубочистки (сдать вместе с другими мусором)",
            "toothpastetube": "Тюбик_зубной_пасты (сдать вместе с другими мусором)",
            "toothbrush": "Зубная_щетка (сдать вместе с другими мусором)",
            "thermometer": "Ртутный_термометр (сдать в медучреждение для утилизации)",
            "tabletcapsule": "Таблетки (сдать в аптеку для утилизации)",
            "rag": "Тряпка (можно использовать для уборки, затем выбросить вместе с другими мусором)",
            "plasticene": "Пластелин (выбросить вместе с другими мусором)",
            "plasticbottle": "Пластиковая_бутылка (сдать на переработку)",
            "plasticbag": "Пластиковый_пакет (сдать на переработку)",
            "pesticidebottle": "Бутылка_с_химическими_веществами (сдать на специальную площадку для опасных отходов)",
            "penholder": "Пенал (выбросить вместе с другими мусором)",
            "nut": "Орехи (можно использовать в пищу или выбросить вместе с другими мусором)",
            "newspaper": "Газеты (сдать на переработку)",
            "napkin": "Салфетки (выбросить вместе с другими мусором)",
            "nailpolishbottle": "Лак_для_ногтей (сдать на специальную площадку для опасных отходов)",
            "milkbox": "Пакет_молока (сдать на переработку)",
            "medicinebottle": "Емкость_для_лекарств (сдать в аптеку для утилизации)",
            "leftovers": "Объедки (использовать в пищу или выбросить вместе с другими мусором)",
            "leaflet": "Журнальные_листовки (утилизировать через бумажный контейнер или сдать на переработку в пункт приема бумаги)",
            "glassbottle": "Стеклянная_бутылка (Можно сдать в пункт переработки стекла или выбросить в контейнер для стекла)",
            "facialmask": "Маска_для_лица (Следует выбросить в контейнер для мусора. Не выбрасывайте использованные маски на улицу или в природу, так как они могут быть опасными для животных и окружающей среды.)",
            "diapers": "Подгузники (Следует выбросить в контейнер для мусора. Не выбрасывайте использованные подгузники на улицу или в природу, так как они могут быть опасными для животных и окружающей среды.)",
            "cigarettebutt": "Окурок (Не выбрасывайте на улицу или в природу, так как они могут загрязнять окружающую среду и быть опасными для животных. Следует выбросить в мусор.)",
            "chopsticks": "Деревянные_палочки (Можно использовать в качестве поддонов для растений или сдать в пункт переработки дерева.)",
            "carton": "Картон (Можно сдать в пункт переработки бумаги или выбросить в контейнер для бумаги)",
            "cans": "Жестяные_банки (Можно сдать в пункт переработки металла или выбросить в контейнер для металлолома)",
            "bulb": "Лампочки (Следует сдать в специальный пункт для утилизации опасных отходов.)",
            "bread": "Хлеб (Можно утилизировать в компост.)",
            "bowlsanddishes": "Посуда (Если посуда разбивается или трескается, то следует выбросить в мусор. Если посуда еще может использоваться, то можно сдать в благотворительный фонд.)",
            "battery": "Батарейки (Следует сдать в специальный пункт для утилизации опасных отходов.)",
            "bandaid": "Лейкопластырь (Следует выбросить в мусор.)"
        ]
        
        var outputString = inputString
        
        for (key, value) in replacements {
            outputString = outputString.replacingOccurrences(of: key, with: value)
        }
        
        return outputString
    }

    
    
    func classifyImage(image: UIImage) {
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create CIImage from UIImage.") }
        // Создаем запрос на классификацию
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation] else { fatalError("Unexpected result type from VNCoreMLRequest.") }
            // Фильтруем результаты и оставляем только наиболее вероятные классы
            let topResults = results.filter({ $0.confidence > 0.1 }).prefix(3)
            // Создаем массив строк для каждого класса и его вероятности
            let resultStrings = topResults.map({ "\($0.identifier): \($0.confidence)" })
            print(resultStrings)
            print(type(of: resultStrings))
            
            // Создаем строку с наименованиями и вероятностями классов с помощью символа перевода строки
            let resultString = topResults.map({ "\($0.identifier): " + String(format: "%.2f", $0.confidence * 100) + "%" }).joined(separator: "\n\n")

            let out = self.descriptionString(inputString: resultString)
            print(out)
            
            // Создаем NSMutableAttributedString с результатами классификации
            let attributedString = NSMutableAttributedString(string: out)
            // Добавляем стили для отображения результатов в столбик
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            // Выводим строку с результатами в пользовательский интерфейс
            DispatchQueue.main.async {
                self.classificationLabel.attributedText = attributedString
            }
        }
        // Выполняем запрос на классификацию
        let handler = VNImageRequestHandler(ciImage: ciImage)
        try! handler.perform([request])
    }
    
    
    
}
