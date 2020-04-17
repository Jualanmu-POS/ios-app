//
//  ChartCell.swift
//  JualanMu
//
//  Created by Eibiel Sardjanto on 20/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit
import Charts

class ChartCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var xAxisLabel: UILabel!
    @IBOutlet weak var yAxisLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /**
     Setup chart based on period and quantity of items
     - Parameters:
        - qty : day or hour to be shown
        - period : quantity of items
     */
    func customizeChart(qty: [Int] = [10, 15, 35, 44, 10, 22, 51], period: [Double] = [6, 9, 12, 15, 18, 21, 24]) {
      // TO-DO: customize the chart here
        
        // 1. Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<qty.count {
          let dataEntry = ChartDataEntry(x: period[i], y: Double(qty[i]))
          dataEntries.append(dataEntry)
        }
        
        // 2. Set ChartDataSet
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
        
        // 3. Set ChartData
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        lineChartData.setValueFormatter(formatter)
        
        //Chart Properties
        let gradientColors = [ChartColorTemplates.colorFromString("#f7d177").cgColor, ChartColorTemplates.colorFromString("#eca442").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        lineChartDataSet.fillAlpha = 1
        lineChartDataSet.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
        lineChartDataSet.drawFilledEnabled = true
        lineChartDataSet.mode = .horizontalBezier
        lineChartDataSet.circleRadius = 5
        lineChartDataSet.setCircleColor(#colorLiteral(red: 0.8156862745, green: 0.0431372549, blue: 0.0431372549, alpha: 1))
        lineChartDataSet.circleHoleRadius = 0
        lineChartDataSet.setColor(#colorLiteral(red: 1, green: 0.8206087947, blue: 0.2826492786, alpha: 1))
        lineChart.xAxis.labelPosition = .bottom
        lineChart.rightAxis.enabled = false
        lineChart.legend.enabled = false
        // 4. Assign it to the chart’s data
        lineChart.data = lineChartData
    }
    
    func setupView() {
        titleLabel.text = "Grafik Penjualan"
        xAxisLabel.text = "Jam"
        yAxisLabel.text = "Jumlah Barang"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
