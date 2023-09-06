//
//  ViewController.swift
//  TaxApp
//
//  Created by kaoru matsunaga on 2023/09/04.
//

import UIKit

class ViewController: UITableViewController {
    // UI要素のアウトレット接続
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var taxSegmentedControl: UISegmentedControl!
    @IBOutlet weak var taxIncludedPriceLabel: UILabel!
    
    // 税込価格と税率を保存するための配列
    var prices: [(price: Double, taxRate: Double)] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // セルの登録
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PriceCell")
    }
    
    // 原価が変更されたときのアクション
    @IBAction func priceChanged(_ sender: UITextField) {
        updateTaxIncludedPrice()
    }
    
    // 税率が変更されたときのアクション
    @IBAction func taxRateChanged(_ sender: UISegmentedControl) {
        updateTaxIncludedPrice()
    }
    
    // 追加ボタンがタップされたときのアクション
    @IBAction func addButtonTapped(_ sender: UIButton) {
        if let price = Double(taxIncludedPriceLabel.text?.replacingOccurrences(of: "¥", with: "") ?? "") {
            
            //追加 0円の場合は追加しない
            if price == 0.0 {
                       return
                   }
            
            let taxRate = taxSegmentedControl.selectedSegmentIndex == 0 ? 0.10 : 0.08
            prices.append((price: price, taxRate: taxRate))
            self.tableView.reloadData()
        }
    }
    
    // 合計ボタンがタップされたときのアクション
    //   @IBAction func totalButtonTapped(_ sender: UIButton) {
    //     print("totalButtonTapped called")  // ログ追加
    // 画面遷移を実行
    //    performSegue(withIdentifier: "toTotal", sender: nil)
    //}
    
    // 画面遷移の前にデータを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Destination ViewController: \(segue.destination)")  // ログ追加
        if let totalVC = segue.destination as? TotalViewController {
            totalVC.totalAmount = prices.reduce(0) { $0 + $1.price }
            print("Total Amount in prepare: \(totalVC.totalAmount)")  // ログ出力
        }
    }
    
    // 税込価格を計算してラベルに表示するメソッド
    func updateTaxIncludedPrice() {
        if let price = Double(priceTextField.text ?? "") {
            let taxRate = taxSegmentedControl.selectedSegmentIndex == 0 ? 0.10 : 0.08
            let taxIncludedPrice = price * (1 + taxRate)
            taxIncludedPriceLabel.text = "¥" + String(format: "%.2f", taxIncludedPrice)
        } else {
            taxIncludedPriceLabel.text = "¥0.00"
        }
    }
    
    // テーブルビューの行数を返す
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prices.count
    }
    
    // 各行の内容を設定
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PriceCell", for: indexPath)
        let priceInfo = prices[indexPath.row]
        cell.textLabel?.text = "¥\(priceInfo.price) (\(priceInfo.taxRate * 100)%)"
        return cell
    }
    
}
