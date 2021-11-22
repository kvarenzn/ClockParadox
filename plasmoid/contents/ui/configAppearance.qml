import QtQuick 2.0
import QtQuick.Controls 2.15 as QtControls
import QtQuick.Layouts 1.0 as QtLayouts
import org.kde.kirigami 2.5 as Kirigami

QtLayouts.ColumnLayout {
	id: appearancePage

	signal configurationChanged
	
	property string cfg_romanFontFamily
	property string cfg_arabicFontFamily

	property alias cfg_enableGlowEffect: enableGlowEffectCheckBox.checked
	property alias cfg_glowRadius: glowRadiusSpinBox.value
	property alias cfg_glowSamples: glowSamplesSpinBox.value
	property alias cfg_glowSpread: glowSpreadSpinBox.value

	onCfg_romanFontFamilyChanged: {
		if (cfg_romanFontFamily) {
			for (let i = 0, j = fontsModel.count; i < j; i ++) {
				if (fontsModel.get(i).value == cfg_romanFontFamily) {
					romanFontFamilyComboBox.currentIndex = i
					break
				}
			}
		}
	}

	onCfg_arabicFontFamilyChanged: {
		if (cfg_arabicFontFamily) {
			for (let i = 0, j = fontsModel.count; i < j; i ++) {
				if (fontsModel.get(i).value == cfg_arabicFontFamily) {
					arabicFontFamilyComboBox.currentIndex = i
					break
				}
			}
		}
	}

	ListModel {
		id: fontsModel
		Component.onCompleted: {
			let arr = []
			arr.push({
				text: i18nc('Use default font', 'Default'),
				value: ''
			})

			let fonts = Qt.fontFamilies()
			let foundIndex = 0

			for (let i = 0, j = fonts.length; i < j; i ++) {
				arr.push({
					text: fonts[i],
					value: fonts[i]
				})
			}

			append(arr)
		}
	}

	Kirigami.FormLayout {
		QtLayouts.Layout.fillWidth: true
		anchors.fill: parent

		QtControls.CheckBox {
			id: enableGlowEffectCheckBox
			text: i18n('Enable glow effect')
			Kirigami.FormData.label: i18n('Effects:')
		}

		QtControls.SpinBox {
			id: glowRadiusSpinBox
			enabled: cfg_enableGlowEffect
			Kirigami.FormData.label: i18n('Glow radius:')
			from: 0
			to: 50
		}

		QtControls.SpinBox {
			id: glowSamplesSpinBox
			enabled: cfg_enableGlowEffect
			Kirigami.FormData.label: i18n('Glow samples:')
			from: 0
			to: 100
		}

		QtControls.SpinBox {
			id: glowSpreadSpinBox
			enabled: cfg_enableGlowEffect
			Kirigami.FormData.label: i18n('Glow spread:')
			from: 0
			to: 10000
			stepSize: 100

			property int decimals: 4
			property real realValue: value / 10000

			validator: DoubleValidator {
				bottom: 0
				top: 10000
			}

			textFromValue: function(value, locale) {
				return Number(value / 10000).toLocaleString(locale, 'f', glowSpreadSpinBox.decimals)
			}

			valueFromText: function(text, locale) {
				return Number.fromLocaleString(locale, text) * 10000
			}
		}


		Item {
			Kirigami.FormData.isSection: true
		}

		QtControls.ComboBox {
			id: romanFontFamilyComboBox
			Kirigami.FormData.label: i18n('Font for roman numerals:')
			QtLayouts.Layout.fillWidth: true
			currentIndex: 0
			QtLayouts.Layout.minimumWidth: Kirigami.Units.gridUnit * 10
			model: fontsModel

			textRole: 'text'

			onCurrentIndexChanged: {
				let current = model.get(currentIndex)
				if (current) {
					cfg_romanFontFamily = current.value
					appearancePage.configurationChanged()
				}
			}
		}

		QtControls.ComboBox {
			id: arabicFontFamilyComboBox
			Kirigami.FormData.label: i18n('Font for arabic numerals:')
			QtLayouts.Layout.fillWidth: true
			currentIndex: 0
			QtLayouts.Layout.minimumWidth: Kirigami.Units.gridUnit * 10
			model: fontsModel

			textRole: 'text'

			onCurrentIndexChanged: {
				let current = model.get(currentIndex)
				if (current) {
					cfg_arabicFontFamily = current.value
					appearancePage.configurationChanged()
				}
			}
		}
	}

	Item {
		QtLayouts.Layout.fillHeight: true
	}
}
