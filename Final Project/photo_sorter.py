import PySimpleGUI as sg
from PIL import Image, ImageTk

import numpy as np
import os
import io

from pprint import pprint

import object_detection
import main

def folder_size(folder_path):
    return len([f for f in os.listdir(folder_path) if not f.startswith('.')])

def get_filenames(folder_path):
    return [filename for filename in os.listdir(folder_path)]

def get_filepaths(folder_path):
    return [os.path.join(folder_path, filename) for filename in os.listdir(folder_path)]

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

def get_img_data(f, maxsize=(1200, 850)):
    img = Image.open(f)
    img.thumbnail(maxsize)

    bio = io.BytesIO()
    img.save(bio, format="PNG")
    del img
    return bio.getvalue()

def ImageViewer(filenames, folder_path, selected_filters, filter_objects, confidence):
    print(filenames[0], folder_path, os.path.join(folder_path, filenames[0]))
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
        if event2 == sg.WIN_CLOSED or event2 == 'Exit':
            break
        elif event2 == 'file_list':
            window2['image_col'].update(visible=True)
            try:
                path = os.path.join(folder_path, values2['file_list'][0])
                window2['image_view'].update(data=get_img_data(path))
                window2['image_path'].update('Filepath: %s' % (path, ))
            except:
                window2['image_path'].update('Unable to Open File!')

            objects = filter_objects[values2['file_list'][0]]
            window2['selected_conf'].update('')
            for key, val in objects.items():
                if key in selected_filters and val >= confidence:
                    window2['selected_conf'].print('%s [%.4f %% Confidence]' % (key, val * 100))


    window2.close()
    return

def ImageSorter(filenames, input_folder, output_folder):
    layout = [
        [sg.Text('Near Duplicate Sorter', size=(25, 1), font=("Helvetica", 18, "bold"))],
        [sg.Text("Minimum threshold to be detected as a match", size=(40, 1)), sg.Input("400", key='match_limit', enable_events=True)],
        [sg.Check('Recompute Features', key='recompute_features'), sg.Check('Recompute Matches', key='recompute_matches')],
        [sg.Button('Detect Features', key='detect_feature'), sg.Button('Match Features', key='match_feature', disabled=True, tooltip="Please run 'Detect Features' first.")],
        [sg.Output(size=(80, 10))],
        [sg.Exit()]
    ]

    window3 = sg.Window('Feature Detection and Matching', layout)
    features = {}

    while True:
        event3, values3 = window3.read()
        print(event3, values3)

        if event3 == sg.WIN_CLOSED or event3 == 'Exit':
            break
        elif event3 == 'detect_feature':
            print()
            features = main.compute_features(input_folder, filenames, values3['recompute_features'])
            window3['match_feature'].update(disabled=False)
            window3['match_feature'].set_tooltip('Detect matches between images with common features')
        elif event3 == 'match_feature':
            print()
            matches = main.compute_matches(features, int(values3['match_limit']), input_folder, values3['recompute_matches'])
            main.write_output(matches, input_folder, output_folder)

    window3.close()
    return

sg.theme('Dark Gray 10')
window_width = 100
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
    [sg.Col([[sg.Text('', size=(25, 1), font=("Helvetica", 12, "italic"), key='sorting_text')]], visible=False, key='sorting_count')],
    [sg.Button('Sort Images', disabled=True, tooltip="Please select a valid input and output directory", key='sort_btn'), sg.Exit()]
]

window = sg.Window('Photo Sorter Final Project', layout, enable_close_attempted_event=True)#, size=(1000, 600))

filter_objects = {}
input_files = []
sorting_files = []

while True:
    event, values = window.read()
    print(event, values)

    if (event == sg.WINDOW_CLOSE_ATTEMPTED_EVENT or event == 'Exit') and sg.popup_yes_no('Do you really want to exit?') == 'Yes':
        break

    if event == 'input_folder':
        window['image_count'].update('%d Images Loaded' % (folder_size(values['input_folder'])), visible = True)
        window['filter_images'].update(visible = True)

        window['sorting_text'].update('Sorting %d Images...' % (folder_size(values['input_folder'])))
        window['sorting_count'].update(visible = True)

        input_files = get_filenames(values['input_folder'])
        sorting_files = input_files

        if len(values['output_folder']) > 0:
            window['sort_btn'].update(disabled=False)
            window['sort_btn'].set_tooltip('Sort the selected images')

            window['detect_btn'].update(disabled=False)
            window['detect_btn'].set_tooltip('Detect objects in the selected images')

    if event == 'output_folder':
        if len(values['input_folder']) > 0:
            window['sort_btn'].update(disabled=False)
            window['sort_btn'].set_tooltip('Sort the selected images')

            window['detect_btn'].update(disabled=False)
            window['detect_btn'].set_tooltip('Detect objects in the selected images')

    elif event == 'detect_btn':
        if folder_size(values['input_folder']) > 0:
            filter_objects = object_detection.process_folder(values['input_folder'])
            class_counts = object_detection.get_class_counts(filter_objects, float(values['filter_conf']))

            pprint(class_counts)
            list_values = []
            for key, value in class_counts.items():
                list_values.append('%s (%s)' % (key, value))

            window['filter_objects'].update(visible=True)
            window['filter_objects_list'].update(values = tuple(sorted(list_values)))
        else:
            # TODO: Error message maybe?
            pass

    elif event == 'filter_conf':
        window['filter_objects'].update(visible=False)

    elif event == 'filter_objects_list':
        objects_selected = len(values['filter_objects_list']) > 0

        window['view_objects_btn'].update(disabled=not objects_selected)
        window['filter_btn'].update(disabled=not objects_selected)
        window['filter_out_btn'].update(disabled=not objects_selected)

    elif event == 'view_objects_btn':
        selected = [x.split(" (")[0] for x in values['filter_objects_list']]
        print(filter_files(input_files, selected, filter_objects, float(values['filter_conf']))
              )
        ImageViewer(filter_files(input_files, selected, filter_objects, float(values['filter_conf'])), values['input_folder'], selected, filter_objects, float(values['filter_conf']))

    elif event == 'filter_btn':
        selected = [x.split(" (")[0] for x in values['filter_objects_list']]

        sorting_files = filter_files(input_files, selected, filter_objects, float(values['filter_conf']))
        window['sorting_text'].update('Sorting %d Images...' % (len(sorting_files)))
        print(sorting_files)
    elif event == 'filter_out_btn':
        selected = [x.split(" (")[0] for x in values['filter_objects_list']]
        sorted_out = filter_files(input_files, selected, filter_objects, float(values['filter_conf']))

        sorting_files = list(np.setdiff1d(input_files, sorted_out))
        window['sorting_text'].update('Sorting %d Images...' % (len(sorting_files)))
        print(sorting_files)

    elif event == 'sort_btn':
        ImageSorter(sorting_files, values['input_folder'], values['output_folder'])

window.close()