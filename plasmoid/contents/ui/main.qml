import QtQuick 2.15
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import QtGraphicalEffects 1.15
import QtQuick.Shapes 1.15

Item {
	id: analogclock

	width: PlasmaCore.Units.gridUnit * 15
	height: PlasmaCore.Units.gridUnit * 15

	property int hours
	property int minutes
	property int seconds

	property bool enableGlowEffect: plasmoid.configuration.enableGlowEffect
	property int glowRadius: plasmoid.configuration.glowRadius
	property int glowSamples: plasmoid.configuration.glowSamples
	property real glowSpread: plasmoid.configuration.glowSpread / 10000

	Plasmoid.backgroundHints: 'NoBackground'
	Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

	PlasmaCore.DataSource {
		id: dataSource
		engine: 'time'
		connectedSources: 'Local'
		interval: 1000
		onDataChanged: {
			let date = new Date(data.Local.DateTime);
			hours = date.getHours();
			minutes = date.getMinutes();
			seconds = date.getSeconds();
		}

		Component.onCompleted: {
			onDataChanged();
		}
	}

	Plasmoid.compactRepresentation: Item {
		id: representation

		Layout.minimumWidth: plasmoid.formFactor !== PlasmaCore.Types.Vertical ? representation.height : PlasmaCore.Units.gridUnit
		Layout.minimumHeight: plasmoid.formFactor === PlasmaCore.Types.Vertical ? representation.width : PlasmaCore.Units.gridUnit

		MouseArea {
			anchors.fill: parent
		}

		Item {
			id: clock
			anchors.fill: parent

			property real a: Math.min(width, height)
			property real r: a / 2
			property real d: a / 128
			property real dd: d / 2

			layer.enabled: true
			layer.samples: 8

			Repeater {
				model: [
					{
						circleRadius: clock.r - clock.d,
						circleWidth: clock.d * 1.5
					},
					{
						circleRadius: clock.d * 52,
						circleWidth: clock.d * 1.5
					},
					{
						circleRadius: clock.d * 39 + clock.dd,
						circleWidth: clock.dd * 1.25
					},
					{
						circleRadius: clock.d * 39 * 5 / 9,
						circleWidth: clock.dd
					}
				]

				Shape {
					id: circle
					anchors.fill: clock

					smooth: true
					antialiasing: true

					ShapePath {
						strokeWidth: modelData.circleWidth
						strokeColor: 'white'
						fillColor: 'transparent'

						PathAngleArc {
							radiusX: modelData.circleRadius
							radiusY: modelData.circleRadius

							centerX: circle.width / 2
							centerY: circle.height / 2

							sweepAngle: 360
						}
					}
				}
			}

			property real fontR: clock.dd * 115

			Repeater {
				model: ['XII', 'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X', 'XI']

				Text {
					text: modelData
					color: 'white'
					font {
						family: plasmoid.configuration.romanFontFamily || PlasmaCore.Theme.defaultFont.family
						pointSize: clock.dd * 9
					}

					x: clock.width / 2 - width / 2 + clock.fontR * Math.sin(index * Math.PI / 6)
					y: clock.height / 2 - height / 2 - clock.fontR * Math.cos(index * Math.PI / 6)

					smooth: true
					antialiasing: true

					rotation: index * 30
				}
			}

			Repeater {
				model: 60

				Shape {
					anchors.fill: parent

					ShapePath {
						strokeWidth: 0
						fillColor: 'white'

						startX: clock.width / 2 + clock.dd * 377 / 4
						startY: clock.height / 2 + clock.dd / 4

						PathLine {
							x: clock.width / 2 + clock.dd * 377 / 4
							y: clock.height / 2 - clock.dd / 4
						}

						PathLine {
							x: clock.width / 2 + clock.dd * 347 / 4
							y: clock.height / 2 - clock.dd / 8
						}

						PathLine {
							x: clock.width / 2 + clock.dd * 347 / 4
							y: clock.height / 2 + clock.dd / 8
						}

						PathLine {
							x: clock.width / 2 + clock.dd * 377 / 4
							y: clock.height / 2 + clock.dd / 4
						}
					}

					rotation: index * 6
				}
			}

			Repeater {
				model: 12

				Shape {
					anchors.fill: parent

					ShapePath {
						strokeWidth: 0
						fillColor: 'white'

						startX: clock.width / 2 + clock.dd * 383 / 4
						startY: clock.height / 2 + clock.dd * 3 / 4

						PathLine {
							x: clock.width / 2 + clock.dd * 383 / 4
							y: clock.height / 2 - clock.dd * 3 / 4
						}

						PathLine {
							x: clock.width / 2 + clock.dd * 341 / 4
							y: clock.height / 2 - clock.dd / 4
						}

						PathLine {
							x: clock.width / 2 + clock.dd * 341 / 4
							y: clock.height / 2 + clock.dd / 4
						}

						PathLine {
							x: clock.width / 2 + clock.dd * 383 / 4
							y: clock.height / 2 + clock.dd * 3 / 4
						}
					}

					rotation: index * 30
				}
			}

			property real fontR1: clock.d * 36

			Repeater {
				model: 12

				Text {
					text: index ? index * 5 : 60
					color: 'white'
					font {
						family: plasmoid.configuration.arabicFontFamily || PlasmaCore.Theme.defaultFont.family
						pointSize: clock.dd * 7
					}

					x: clock.width / 2 - width / 2 + clock.fontR1 * Math.sin(index * Math.PI / 6)
					y: clock.height / 2 - height / 2 - clock.fontR1 * Math.cos(index * Math.PI / 6)

					smooth: true
					antialiasing: true

					rotation: 3 < index && index < 9 ? index * 30 + 180 : index * 30
				}
			}

			Repeater {
				model: 12

				Shape {
					anchors.fill: parent

					ShapePath {
						strokeWidth: clock.dd
						strokeColor: 'white'
						fillColor: 'transparent'

						PathAngleArc {
							radiusX: clock.fontR1
							radiusY: clock.fontR1

							centerX: clock.width / 2
							centerY: clock.height / 2

							startAngle: -25
							sweepAngle: 20
						}
					}

					rotation: index * 30
				}
			}

			Shape {
				id: hourHand
				anchors.fill: parent

				property real length: clock.d * 39 / 20 * 9 

				ShapePath {
					strokeWidth: clock.d
					strokeColor: 'white'
					fillColor: 'transparent'

					startX: clock.width / 2 - hourHand.length / 20
					startY: clock.height / 2

					PathLine {
						relativeX: hourHand.length / 10 * 7
						relativeY: hourHand.length / 20
					}

					PathLine {
						relativeX: hourHand.length / 10 * 3
						relativeY: - hourHand.length / 20
					}

					PathLine {
						relativeX: - hourHand.length / 10 * 3
						relativeY: - hourHand.length / 20
					}

					PathLine {
						relativeX: - hourHand.length / 10 * 7
						relativeY: hourHand.length / 20
					}
				}

				rotation: hours * 30 + minutes / 2 - 90
			}

			Shape {
				id: minuteHand
				anchors.fill: parent

				property real length: clock.dd * 65

				ShapePath {
					strokeWidth: 0
					fillColor: 'white'

					startX: clock.width / 2 - minuteHand.length / 20
					startY: clock.height / 2

					PathLine {
						relativeX: minuteHand.length / 10 * 7
						relativeY: minuteHand.length / 20
					}

					PathLine {
						relativeX: minuteHand.length / 10 * 3
						relativeY: - minuteHand.length / 20
					}

					PathLine {
						relativeX: - minuteHand.length / 10 * 3
						relativeY: - minuteHand.length / 20
					}

					PathLine {
						relativeX: - minuteHand.length / 10 * 7
						relativeY: minuteHand.length / 20
					}
				}

				rotation: minutes * 6 + seconds / 10 - 90
			}

			Shape {
				id: secondHand
				anchors.fill: parent

				property real length: clock.r / 8 * 7

				ShapePath {
					strokeWidth: clock.dd * 1.25
					strokeColor: 'white'
					fillColor: 'transparent'

					startX: clock.width / 2 - secondHand.length / 40
					startY: clock.height / 2

					PathLine {
						relativeX: secondHand.length
						relativeY: 0
					}
				}

				transform: Rotation {
					angle: seconds * 6 - 90
					origin {
						x: clock.width / 2
						y: clock.height / 2
					}
					Behavior on angle {
						RotationAnimation {
							duration: PlasmaCore.Units.longDuration
							direction: RotationAnimation.Clockwise
							easing.type: Easing.OutElastic
							easing.overshoot: 0.5
						}
					}
				}
			}

			Shape {
				id: pin
				anchors.fill: parent

				smooth: true
				antialiasing: true

				ShapePath {
					strokeWidth: 0
					fillColor: 'white'

					PathAngleArc {
						radiusX: clock.d
						radiusY: clock.d

						centerX: parent.width / 2
						centerY: parent.height / 2

						sweepAngle: 360
					}
				}
			}

			layer.effect: Glow {
				color: enableGlowEffect ? 'white' : 'transparent'
				cached: true

				radius: enableGlowEffect ? glowRadius : 0
				samples: enableGlowEffect ? glowSamples : 0
				spread: enableGlowEffect ? glowSpread : 0
			}
		}
	}
}
