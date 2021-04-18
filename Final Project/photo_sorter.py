import PySimpleGUI as sg
import os
from pprint import pprint

def folder_size(folder_path):
    return len([f for f in os.listdir(folder_path)])

sg.theme('Dark Gray 10')
layout = [[sg.Text('Photo Sorter', size=(20, 1), font=("Helvetica", 18))],
          [sg.Text('Input Image Folder', size=(15, 1)), sg.Input(key='-INPUT FILE-', enable_events=True), sg.FolderBrowse()],
          [sg.Text('Output Folder', size=(15, 1)), sg.Input(key='-OUTPUT FILE-', enable_events=True), sg.FolderBrowse()],
          [sg.Text('', size=(20, 1), key='image_count')],
          [sg.Button('Sort Images'), sg.Exit()]]

window = sg.Window('Photo Sorter Final Project', layout, enable_close_attempted_event=True, size=(1000, 600))

while True:
    event, values = window.read()
    print(event, values)
    if event == '-INPUT FILE-':
        window['image_count'].update('%d Images Loaded!' % (folder_size(values['-INPUT FILE-'])))
        print('Images Loaded:', folder_size(values['-INPUT FILE-']))
    elif event == 'Sort Images':
        pass
    if (event == sg.WINDOW_CLOSE_ATTEMPTED_EVENT or event == 'Exit') and sg.popup_yes_no('Do you really want to exit?') == 'Yes':
        break

window.close()