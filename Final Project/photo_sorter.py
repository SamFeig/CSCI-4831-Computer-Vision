import io
import os

import PySimpleGUI as sg
import numpy as np
from PIL import Image

import feature_detector
import object_detection

# Return number of files in folder
def folder_size(folder_path):
    return len([f for f in os.listdir(folder_path) if not f.startswith('.')])

# Return all filesnames in folder
def get_filenames(folder_path):
    return [filename for filename in os.listdir(folder_path) if not filename.startswith('.')]

# Return full filepaths for files in folder
def get_filepaths(folder_path):
    return [os.path.join(folder_path, filename) for filename in os.listdir(folder_path)]

# Filter files by detected object(s)
def filter_files(filenames, selected, filter_objects, confidence):
    filtered = []
    for file in filenames:
        classes = filter_objects[file]
        match = False
        for x in selected:
            if x in classes.keys() and classes[x] >= confidence:
                match = True
        if match:
            filtered.append(file)
    return filtered

# Function logic from PySimpleGUI Tutorial
# https://github.com/PySimpleGUI/PySimpleGUI/blob/master/DemoPrograms/Demo_Img_Viewer.py
# Convert image to format able to be represented in GUI
def get_img_data(f, maxsize=(1200, 850)):
    img = Image.open(f)
    img.thumbnail(maxsize)

    bio = io.BytesIO()
    img.save(bio, format="PNG")
    del img
    return bio.getvalue()

# Image viewer for detected objects
def ImageViewer(filenames, folder_path, selected_filters, filter_objects, confidence):
    layout2 = [[
        sg.Col([
            [sg.Text('Image List', font=("Helvetica", 14, "bold"))],
            [sg.Text('Filters: %s' % (', '.join(selected_filters)), font=("Helvetica", 12, "italic"))],
            [sg.Listbox(values=filenames, size = (60, max(30, len(filenames))), enable_events=True, key='file_list')],
            [sg.Text('Selected Image Objects', font=("Helvetica", 12, "italic"))],
            [sg.Multiline(disabled=True, size=(60, len(selected_filters)), key='selected_conf')],
            [sg.Exit()]
        ]),
        sg.VSeparator(),
        sg.Col([
            [sg.Text('Filepath', size=(150, 1), key='image_path')],
            [sg.Image(key='image_view')]
        ], visible=False, key='image_col')
    ]]

    window2 = sg.Window('Image Viewer', layout2)

    while True:
        event2, values2 = window2.read()
        # Close window logic
        if event2 == sg.WIN_CLOSED or event2 == 'Exit':
            break
        elif event2 == 'file_list':
            # Show image viewer
            window2['image_col'].update(visible=True)
            try:
                # Try to show the image
                path = os.path.join(folder_path, values2['file_list'][0])
                window2['image_view'].update(data=get_img_data(path))
                window2['image_path'].update('Filepath: %s' % (path, ))
            except:
                # If invalid image/metadata, display error message
                window2['image_path'].update('Unable to Open File!')

            # Get confidence values for current image and display them
            objects = filter_objects[values2['file_list'][0]]
            window2['selected_conf'].update('')
            for key, val in objects.items():
                if key in selected_filters and val >= confidence:
                    window2['selected_conf'].print('%s [%.4f %% Confidence]' % (key, val * 100))


    window2.close()
    return

# Window for running feature detection, matching, and sorting
def ImageSorter(filenames, input_folder, output_folder):
    layout = [
        [sg.Text('Near Duplicate Sorter', size=(25, 1), font=("Helvetica", 18, "bold"))],
        [sg.Text("Minimum threshold to be detected as a match (number of matches)", size=(60, 1)), sg.Input("400", key='match_limit', size=(10, 1), enable_events=True)],
        [sg.Check('Recompute Features', key='recompute_features'), sg.Check('Recompute Matches', key='recompute_matches')],
        [sg.Button('Detect Features', key='detect_feature'), sg.Button('Match Features', key='match_feature', disabled=True, tooltip="Please run 'Detect Features' first.")],
        [sg.Output(size=(80, 10))],
        [sg.Exit()]
    ]

    window3 = sg.Window('Feature Detection and Matching', layout)
    features = {}

    while True:
        try:
            event3, values3 = window3.read()

            if event3 == sg.WIN_CLOSED or event3 == 'Exit':
                break
            elif event3 == 'detect_feature':
                print()
                features = feature_detector.compute_features(input_folder, filenames, values3['recompute_features'])
                window3['match_feature'].update(disabled=False)
                window3['match_feature'].set_tooltip('Detect matches between images with common features')
            elif event3 == 'match_feature':
                print()
                matches = feature_detector.compute_matches(features, int(values3['match_limit']), input_folder, values3['recompute_matches'])
                feature_detector.write_output(matches, input_folder, output_folder)
        except Exception as e:
            print('An error has occurred:', e)


    window3.close()
    return

# Specify Theme
sg.theme('Dark Gray 10')

# Window width for dividers
window_width = 125

# Main GUI layout
layout = [
    [sg.Text('Photo Sorter', size=(25, 1), font=("Helvetica", 18, "bold"))],
    [sg.Text('Input Image Folder', size=(15, 1)), sg.Input(key='input_folder', size=(100, 1), readonly=True, enable_events=True), sg.FolderBrowse()],
    [sg.Text('Output Folder', size=(15, 1)), sg.Input(key='output_folder', size=(100, 1), readonly=True, enable_events=True), sg.FolderBrowse()],
    [sg.Text('', size=(25, 1), font=("Helvetica", 12, "italic"), visible=False, key='image_count')],
    [sg.Col([
        [sg.Text('_' * window_width)],
        [sg.Text('Filtering', size=(25, 1), font=("Helvetica", 14, "bold"))],
        [sg.Text('Confidence Threshold', size=(20, 1)), sg.Slider(range=(0, 1), default_value=.5, resolution=0.01, size=(20,10), enable_events=True, orientation='horizontal', key='filter_conf')],
        [sg.Button('Detect Objects', disabled=True, tooltip="Please select a valid input and output directory", key='detect_btn')],
        [sg.Col([
            [sg.Text('Detected Objects', size=(25, 1), font=("Helvetica", 12, "italic"))],
            [sg.Listbox(values=(), size=(20, 10), enable_events=True, key='filter_objects_list', select_mode=sg.LISTBOX_SELECT_MODE_MULTIPLE)],
            [sg.Button('View Images', disabled=True, key='view_objects_btn'), sg.Button('Filter by Selected', disabled=True, key='filter_btn'), sg.Button('Filter out Selected', disabled=True, key='filter_out_btn')]
        ], visible=False, key='filter_objects')],
        [sg.Text('_' * window_width)]
    ], key="filter_images", visible=False)],
    [sg.Col([[sg.Text('', size=(50, 1), font=("Helvetica", 12, "bold"), key='sorting_text')]], visible=False, key='sorting_count')],
    [sg.Button('Sort Images', disabled=True, tooltip="Please select a valid input and output directory", key='sort_btn'), sg.Exit()]
]

# Main window
window = sg.Window('Photo Sorter Final Project', layout, enable_close_attempted_event=True)

# Detected objects
filter_objects = {}
# Input folder file list
input_files = []
# Files to sort (after filtering)
sorting_files = []

while True:
    try:
        event, values = window.read()

        # Exit logic
        if (event == sg.WINDOW_CLOSE_ATTEMPTED_EVENT or event == 'Exit') and sg.popup_yes_no('Do you really want to exit?') == 'Yes':
            break

        # Input folder selection
        if event == 'input_folder':
            # Count loaded images
            window['image_count'].update('%d Images Loaded' % (folder_size(values['input_folder'])), visible = True)
            window['filter_images'].update(visible = True)

            # Update sorting text
            window['sorting_text'].update('Sorting %d Images...' % (folder_size(values['input_folder'])), text_color='white')
            window['sorting_count'].update(visible = True)

            # Save input file list
            input_files = get_filenames(values['input_folder'])
            sorting_files = input_files

            # Enable buttons if input and output folder selected
            if len(values['output_folder']) > 0:
                window['sort_btn'].update(disabled=False)
                window['sort_btn'].set_tooltip('Sort the selected images')

                window['detect_btn'].update(disabled=False)
                window['detect_btn'].set_tooltip('Detect objects in the selected images')

        # Output folder selection
        if event == 'output_folder':
            # Enable buttons if input and output folder selected
            if len(values['input_folder']) > 0:
                window['sort_btn'].update(disabled=False)
                window['sort_btn'].set_tooltip('Sort the selected images')

                window['detect_btn'].update(disabled=False)
                window['detect_btn'].set_tooltip('Detect objects in the selected images')

        # Object detection
        elif event == 'detect_btn':
            if folder_size(values['input_folder']) > 0:
                filter_objects = object_detection.process_folder(values['input_folder'])
                class_counts = object_detection.get_class_counts(filter_objects, float(values['filter_conf']))

                list_values = []
                for key, value in class_counts.items():
                    list_values.append('%s (%s)' % (key, value))

                window['filter_objects'].update(visible=True)
                window['filter_objects_list'].update(values = tuple(sorted(list_values)))

        # If confidence is changed, hide currently detected objects
        elif event == 'filter_conf':
            window['filter_objects'].update(visible=False)

        # Select a detected object
        elif event == 'filter_objects_list':
            objects_selected = len(values['filter_objects_list']) > 0

            window['view_objects_btn'].update(disabled=not objects_selected)
            window['filter_btn'].update(disabled=not objects_selected)
            window['filter_out_btn'].update(disabled=not objects_selected)

        # View button, open image viewer with selected image list
        elif event == 'view_objects_btn':
            selected = [x.split(" (")[0] for x in values['filter_objects_list']]
            ImageViewer(filter_files(input_files, selected, filter_objects, float(values['filter_conf'])), values['input_folder'], selected, filter_objects, float(values['filter_conf']))

        # Filter by button
        elif event == 'filter_btn':
            selected = [x.split(" (")[0] for x in values['filter_objects_list']]

            sorting_files = filter_files(input_files, selected, filter_objects, float(values['filter_conf']))
            window['sorting_text'].update('Sorting %d Images... (Filtered by: %s)' % (len(sorting_files), ', '.join(selected)), text_color='yellow')

        # Filter out button
        elif event == 'filter_out_btn':
            selected = [x.split(" (")[0] for x in values['filter_objects_list']]
            sorted_out = filter_files(input_files, selected, filter_objects, float(values['filter_conf']))

            sorting_files = list(np.setdiff1d(input_files, sorted_out))
            window['sorting_text'].update('Sorting %d Images... (Filtered out: %s)' % (len(sorting_files), ', '.join(selected)), text_color='yellow')

        # Sort button, open image sorter with filtered files
        elif event == 'sort_btn':
            ImageSorter(sorting_files, values['input_folder'], values['output_folder'])
    except Exception as e:
        print('An error has occurred:', e)

window.close()