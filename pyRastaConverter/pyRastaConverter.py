import sys
from PyQt5.QtWidgets import QApplication, QWidget, QPushButton, QLabel, QLineEdit, QVBoxLayout, QHBoxLayout
from PyQt5.QtWidgets import QFileDialog, QComboBox, QDoubleSpinBox, QSpinBox, QCheckBox, QGridLayout
from PyQt5.QtGui import QPixmap
from PyQt5.QtCore import Qt

from RasterInstruction import *
from LinearAllocator import *
from InsnSequence import *

class RastaConverterGUI(QWidget):
    def __init__(self):
        super().__init__()
        self.initUI()

    def browse_input_file(self):
        file_dialog = QFileDialog()
        file_dialog.setFileMode(QFileDialog.ExistingFile)
        filename, _ = file_dialog.getOpenFileName(self, "Open File")
        if filename:
            self.input_file_edit.setText(filename)


    def convert(self):
        # Implement conversion logic here
        pass

    def initUI(self):
        main_layout = QVBoxLayout()

        # Image placeholders
        image_layout = QHBoxLayout()
        for i in range(3):
            image_label = QLabel()
            pixmap = QPixmap(320, 240)
            pixmap.fill(Qt.white)
            image_label.setPixmap(pixmap)
            image_layout.addWidget(image_label)
        main_layout.addLayout(image_layout)


        # Main layout for GUI elements
        layout = QGridLayout()

        row = 0
        col = 0

        # Input File
        self.input_file_label = QLabel("Input File:")
        self.input_file_edit = QLineEdit()
        self.input_file_button = QPushButton("Browse")
        self.input_file_button.clicked.connect(self.browse_input_file)
        layout.addWidget(self.input_file_label, row, col)
        layout.addWidget(self.input_file_edit, row, col + 1)
        layout.addWidget(self.input_file_button, row, col + 2)

        row += 1

        # Output Height
        self.output_height_label = QLabel("Output Height:")
        self.output_height_edit = QLineEdit()
        layout.addWidget(self.output_height_label, row, col)
        layout.addWidget(self.output_height_edit, row, col + 1)

        # Continue
        self.continue_checkbox = QCheckBox("Continue")
        layout.addWidget(self.continue_checkbox, row, col + 2)

        row += 1

        # Palette File
        self.palette_file_label = QLabel("Palette File:")
        self.palette_file_edit = QLineEdit()
        layout.addWidget(self.palette_file_label, row, col)
        layout.addWidget(self.palette_file_edit, row, col + 1)

 

        # Dithering Type
        self.dithering_type_label = QLabel("Dithering Type:")
        self.dithering_type_combo = QComboBox()
        self.dithering_type_combo.addItems(["Chess", "Floyd", "2D", "Jarvis", "Simple", "Knoll", "Line", "Line2"])
        layout.addWidget(self.dithering_type_label)
        layout.addWidget(self.dithering_type_combo)

        # Dithering Strength
        self.dithering_strength_label = QLabel("Dithering Strength:")
        self.dithering_strength_spinbox = QDoubleSpinBox()
        self.dithering_strength_spinbox.setRange(0.0, 3.0)
        self.dithering_strength_spinbox.setSingleStep(0.1)
        self.dithering_strength_spinbox.setValue(1.0)
        layout.addWidget(self.dithering_strength_label)
        layout.addWidget(self.dithering_strength_spinbox)

        # Dithering Randomness
        self.dithering_randomness_label = QLabel("Dithering Randomness:")
        self.dithering_randomness_spinbox = QDoubleSpinBox()
        self.dithering_randomness_spinbox.setRange(0.0, 1.0)
        self.dithering_randomness_spinbox.setSingleStep(0.1)
        self.dithering_randomness_spinbox.setValue(0.0)
        layout.addWidget(self.dithering_randomness_label)
        layout.addWidget(self.dithering_randomness_spinbox)

        # Details Picture
        self.details_picture_label = QLabel("Details Picture:")
        self.details_picture_edit = QLineEdit()
        layout.addWidget(self.details_picture_label)
        layout.addWidget(self.details_picture_edit)

        # Details Influence Strength
        self.details_influence_label = QLabel("Details Influence Strength:")
        self.details_influence_spinbox = QDoubleSpinBox()
        self.details_influence_spinbox.setRange(0.0, 10.0)
        self.details_influence_spinbox.setSingleStep(0.1)
        self.details_influence_spinbox.setValue(1.0)
        layout.addWidget(self.details_influence_label)
        layout.addWidget(self.details_influence_spinbox)

        # Resize Filter
        self.resize_filter_label = QLabel("Resize Filter:")
        self.resize_filter_combo = QComboBox()
        self.resize_filter_combo.addItems(["Lanczos", "Box", "Bicubic", "Bilinear", "Bspline", "Catmullrom"])
        layout.addWidget(self.resize_filter_label)
        layout.addWidget(self.resize_filter_combo)

        # Brightness
        self.brightness_label = QLabel("Brightness:")
        self.brightness_spinbox = QSpinBox()
        self.brightness_spinbox.setRange(-100, 100)
        self.brightness_spinbox.setValue(0)
        layout.addWidget(self.brightness_label)
        layout.addWidget(self.brightness_spinbox)

        # Contrast
        self.contrast_label = QLabel("Contrast:")
        self.contrast_spinbox = QSpinBox()
        self.contrast_spinbox.setRange(-100, 100)
        self.contrast_spinbox.setValue(0)
        layout.addWidget(self.contrast_label)
        layout.addWidget(self.contrast_spinbox)

        # Gamma
        self.gamma_label = QLabel("Gamma:")
        self.gamma_spinbox = QDoubleSpinBox()
        self.gamma_spinbox.setRange(0.0, 8.0)
        self.gamma_spinbox.setSingleStep(0.1)
        self.gamma_spinbox.setValue(1.0)
        layout.addWidget(self.gamma_label)
        layout.addWidget(self.gamma_spinbox)

        # Initial Optimization State
        self.init_optimization_label = QLabel("Initial Optimization State:")
        self.init_optimization_combo = QComboBox()
        self.init_optimization_combo.addItems(["Random", "Empty", "Less", "Smart"])
        layout.addWidget(self.init_optimization_label)
        layout.addWidget(self.init_optimization_combo)

        # Output File
        self.output_file_label = QLabel("Output File:")
        self.output_file_edit = QLineEdit()
        layout.addWidget(self.output_file_label)
        layout.addWidget(self.output_file_edit)

        # Number of Solutions
        self.num_solutions_label = QLabel("Number of Solutions:")
        self.num_solutions_spinbox = QSpinBox()
        self.num_solutions_spinbox.setRange(1, 10000)
        self.num_solutions_spinbox.setValue(1)
        layout.addWidget(self.num_solutions_label)
        layout.addWidget(self.num_solutions_spinbox)

        # Color Distance Function
        self.color_distance_label = QLabel("Color Distance Function:")
        self.color_distance_combo = QComboBox()
        self.color_distance_combo.addItems(["YUV", "Euclid", "CIEDE"])
        layout.addWidget(self.color_distance_label)
        layout.addWidget(self.color_distance_combo)

        # Maximum Number of Evaluations
        self.max_evals_label = QLabel("Maximum Number of Evaluations:")
        self.max_evals_spinbox = QSpinBox()
        self.max_evals_spinbox.setRange(1, 1000000000)
        layout.addWidget(self.max_evals_label)
        layout.addWidget(self.max_evals_spinbox)

        # OnOff File
        self.onoff_file_label = QLabel("OnOff File:")
        self.onoff_file_edit = QLineEdit()
        layout.addWidget(self.onoff_file_label)
        layout.addWidget(self.onoff_file_edit)

        # Preprocess
        self.preprocess_checkbox = QCheckBox("Preprocess")
        layout.addWidget(self.preprocess_checkbox)

        # Seed
        self.seed_label = QLabel("Seed:")
        self.seed_edit = QLineEdit()
        layout.addWidget(self.seed_label)
        layout.addWidget(self.seed_edit)

        # Save
        self.save_label = QLabel("Save:")
        self.save_spinbox = QSpinBox()
        self.save_spinbox.setRange(0, 100000)
        self.save_spinbox.setValue(0)
        layout.addWidget(self.save_label)
        layout.addWidget(self.save_spinbox)

        main_layout.addLayout(layout)

        # Convert Button
        self.convert_button = QPushButton("Convert")
        self.convert_button.clicked.connect(self.convert)
        main_layout.addWidget(self.convert_button)

        self.setLayout(main_layout)
        self.setWindowTitle('RastaConverter GUI')


if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = RastaConverterGUI()
    window.show()
    sys.exit(app.exec_())
   
