from paraview.simple import *
import numpy as np
import math
import os

def compute_dim_time(time_nds):
  year_in_seconds=31556952
  rho_0 = 3000
  g = 10
  alpha = 3e-5
  deltaTemp = 1.5e3
  D = 2e6
  mu = 0
  k = 4
  c_p = 1333.333333333333
  kappa = k/(rho_0 * c_p)
  rayleigh = 1e5
  mu = deltaTemp*(alpha * rho_0 * g * pow(D,3.0))/(rayleigh*kappa)
 
#  time_nds = np.array([0.05, 0.1, 0.15])
  time_dim = time_nds/(year_in_seconds*kappa*(1/(math.pow(D,2))))
  return time_dim

def read_file(input_file_path):
  extension = os.path.splitext(input_file_path)[1]
  if (extension == '.pvd'):
    return paraview.simple.PVDReader(FileName=input_file_path)
  elif (extension == '.pvtu') or (extension == '.vtu'):
    return paraview.simple.XMLPartitionedUnstructuredGridReader(FileName=input_file_path)
  else:
    print("Unsupported data format, " + extension)
  
# Set last argument to true to output data file, other wise return data value.
def find_approximate_data_file(reader_sol, time_dim, file_name_or_time_value):
  file_name_prefix = reader_sol.GetPropertyValue('FileName')
  file_name_prefix = file_name_prefix.split(os.path.basename(file_name_prefix))[0]
  time_dim = compute_dim_time()
# If interested in including 0th timestep."
#  time_values = np.array([0])
#  time_steps = np.array([])
#  time_steps_filename = np.array([file_name_prefix + 'solution/solution-00000.pvtu'])
  time_values = np.array([])
  time_steps_filename = np.array([])
  for search_time in time_dim:
    for index, time in enumerate(reader_sol.GetPropertyValue('TimestepValues')):
      if time >= search_time:
        prev_time = reader_sol.GetPropertyValue('TimestepValues')[index-1]
        if math.fabs(prev_time - search_time) < math.fabs(time - search_time):
          time_values = np.append(time_values, prev_time)
          #time_steps = np.append(time_steps, int(index-1))
          time_steps = index-1
        else:
          time_values = np.append(time_values, time)
          #time_steps = np.append(time_steps, int(index))
          time_steps = index

        time_step_suffix = '00000' + str(time_steps)
        time_steps_filename = np.append(time_steps_filename, file_name_prefix + 'solution/solution-' + time_step_suffix[-5:] + '.pvtu')
        break 
  if (file_name_or_time_value):
    return time_steps_filename
  else:
    return time_values

def set_dimensions(view1):
  view1.SetPropertyWithName('OrientationAxesVisibility', 0)
  view1.Background = [1,1,1]

#def set_dimensions(time_value, filename, reader_sol, dp_sol, view1):
#  view1 = CreateRenderView()
#  view1.SetPropertyWithName('ViewSize', [1200,600])
#  Show(reader_sol, view1)
#  dp_sol = view1.GetPropertyValue('Representations')[0]
#  dp_sol.SetPropertyWithName('Scale', [4,4,1])
#  dp_sol.SetPropertyWithName('Position', [-9e6, -0.5e6,0])

def set_solution_temperature(reader_sol, dp_sol, calc):
  PD_index = 0
  for i in xrange(1,len(reader_sol.GetPointDataInformation())):
    metadata_name = reader_sol.GetPointDataInformation()[i].Name
    if (metadata_name == 'T'):
      PD_index = i
      break
  solutionData = reader_sol.PointData[PD_index]
  #solutionData = reader_sol.PointData[3]
  Hide(reader_sol)
  calc.SetPropertyWithName('ResultArrayName', 'Composition')
  calc.SetPropertyWithName('Function', 'T/1500')
  Show(calc)
  dp_sol.LookupTable = MakeBlueToRedLT(0.0,1.0)
  dp_sol.LookupTable.SetPropertyWithName('ColorSpace', 'Diverging')
  apply(dp_sol, 0.0, 1.0, 196./255., 3./255., 28./255.)
  dp_sol.ColorArrayName = reader_sol.GetPointDataInformation()[PD_index].Name

def set_solution_composition(reader_sol, dp_sol):
  PD_index = 0
  for i in xrange(1,len(reader_sol.GetPointDataInformation())):
    metadata_name = reader_sol.GetPointDataInformation()[i].Name
    if (metadata_name == 'composition') or (metadata_name == 'C_1') or (metadata_name == 'VoFC'):
      PD_index = i
      break

  solutionData = reader_sol.PointData[PD_index]
  dp_sol.LookupTable = MakeBlueToRedLT(0.0,1.0)
  dp_sol.LookupTable.SetPropertyWithName('ColorSpace', 'Diverging')
  apply(dp_sol, 0.0, 1.0, 196./255., 3./255., 28./255.)
  dp_sol.ColorArrayName = reader_sol.GetPointDataInformation()[PD_index].Name

def set_solution_time(view1, time_value):
  view1.ViewTime = time_value

def apply(dp_sol, min_a, max_b, R,G,B):
  dp_sol.LookupTable.RGBPoints = [min_a, B, G, R, max_b, R, G, B]

# Code to assemble color bar.
#  bar = CreateScalarBar(LookupTable=dp_sol.LookupTable, Title="Temperature")
#  bar.SetPropertyWithName('ComponentTitle', '')
#  bar.SetPropertyWithName('Orientation', 'Horizontal')
#  bar.SetPropertyWithName('Position', [0.1,0])
#  bar.SetPropertyWithName('TitleFontSize', 10) 
#  GetRenderView().Representations.append(bar)
#  Render(view1)
#  Show(view1)
#  SaveScreenshot(filename, view1)

def path_to_viz_data(dir_DSF, dir_METHODS, METHODS, BOUYANCY_factors):
 
  data_files = [] 
  for dsf in dir_DSF:
    for index, method in enumerate(dir_METHODS):
      for B in BOUYANCY_factors:
        path=dsf +'/' + method + '/' + METHODS[index] + '_Ra_1e5_B_' + B
        data=path+'/solution/'
        if (os.path.exists(path)):
          data_files.append(data + os.listdir(data)[1])
          time = compute_dim_time(np.array([0.02]))
#          print(data + os.listdir(data)[0])
  return data_files

#PASS 1: out-of-phase temperature IC at non dim time t'=0.02
dir_DSF=['density-stratified-fluid', 'density-stratified-fluid-4']
dir_METHODS=['PARTICLES', 'VOF', 'DGBP', 'FEM-EV']
METHODS=['Particles', 'VOF', 'DGBP', 'FEM-EV']
BOUYANCY_factors=['0.0', '0.1', '0.2']
FILENAME_BOUYANCY_factors=['0e0', '1e-1', '2e-1']

viz_data = path_to_viz_data(dir_DSF, dir_METHODS, METHODS, BOUYANCY_factors)
time_tag = '2e-2'

TOP_LEVEL=os.getcwd() 
for dsf in dir_DSF:
  for index, method in enumerate(dir_METHODS):
    if (dsf == 'density-stratified-fluid') and (method == 'PARTICLES'):
      continue
    for index_B, B in enumerate(BOUYANCY_factors):
      path=dsf +'/' + method + '/' + METHODS[index] + '_Ra_1e5_B_' + B
      data_file=path+'/solution.pvd'
      print(data_file)
      if (os.path.exists(data_file)):
        reader_sol = read_file(data_file)
        Show(reader_sol)
        Render()
        view1 = GetActiveView()
        set_dimensions(view1)
        dp_sol = view1.GetPropertyValue('Representations')[0]
        set_solution_composition(reader_sol, dp_sol)
        set_solution_time(view1, compute_dim_time(0.02))
        Render()
        output_image_name = 'COMPOSITION_' + method + '_Ra_1e5_B_' + FILENAME_BOUYANCY_factors[index_B] + '_Time_' + time_tag + '.png'
        paraview.simple.SaveScreenshot(filename=output_image_name, viewOrLayout=view1, ImageQuality=100)
        calc = Calculator(reader_sol)
        set_solution_temperature(reader_sol, dp_sol, calc)
        Render()
        output_image_name = 'TEMPERATURE_' + method + '_Ra_1e5_B_' + FILENAME_BOUYANCY_factors[index_B] + '_Time_' + time_tag + '.png'
        paraview.simple.SaveScreenshot(filename=output_image_name, viewOrLayout=view1, ImageQuality=100)
        Delete(calc)
        Delete(reader_sol)

#PASS 2: in-phase temperature IC at non dim time t'=0.075
dir_DSF=['density-stratified-fluid-2', 'density-stratified-fluid-3']
dir_METHODS=['PARTICLES', 'VOF', 'DGBP', 'FEM-EV']
METHODS=['Particles', 'VOF', 'DGBP', 'FEM-EV']
BOUYANCY_factors=['0.0', '0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9', '1.0']
FILENAME_BOUYANCY_factors=['0e0', '1e-1', '2e-1', '3e-1', '4e-1', '5e-1', '6e-1', '7e-1', '8e-1', '9e-1', '1e0']

viz_data = path_to_viz_data(dir_DSF, dir_METHODS, METHODS, BOUYANCY_factors)
time_tag = '75e-3'
TOP_LEVEL=os.getcwd() 
for dsf in dir_DSF:
  for index, method in enumerate(dir_METHODS):
    if (dsf == 'density-stratified-fluid-2') and (method == 'PARTICLES'):
      continue
    for index_B, B in enumerate(BOUYANCY_factors):
      path=dsf +'/' + method + '/' + METHODS[index] + '_Ra_1e5_B_' + B
      data_file=path+'/solution.pvd'
      if (os.path.exists(data_file)):
        reader_sol = read_file(data_file)
        Show(reader_sol)
        Render()
        view1 = GetActiveView()
        set_dimensions(view1)
        dp_sol = view1.GetPropertyValue('Representations')[0]
        set_solution_composition(reader_sol, dp_sol)
        set_solution_time(view1, compute_dim_time(0.075))
        Render()
        output_image_name = 'COMPOSITION_' + method + '_Ra_1e5_B_' + FILENAME_BOUYANCY_factors[index_B] + '_Time_' + time_tag + '.png'
        paraview.simple.SaveScreenshot(filename=output_image_name, viewOrLayout=view1, ImageQuality=100)
        calc = Calculator(reader_sol)
        set_solution_temperature(reader_sol, dp_sol, calc)
        Render()
        output_image_name = 'TEMPERATURE_' + method + '_Ra_1e5_B_' + FILENAME_BOUYANCY_factors[index_B] + '_Time_' + time_tag + '.png'
        paraview.simple.SaveScreenshot(filename=output_image_name, viewOrLayout=view1, ImageQuality=100)
        Delete(calc)
        Delete(reader_sol)

##dir_DSF=['density-stratified-fluid-3', 'density-stratified-fluid-4', 'density-stratified-fluid', 'density-stratified-fluid-2']
#dir_DSF=['density-stratified-fluid-4']
#  
##dir_METHODS=['PARTICLES', 'VOF', 'DGBP', 'FEM-EV']
##METHODS=['Particles', 'VOF', 'DGBP', 'FEM-EV']
##dir_METHODS=['VOF', 'DGBP', 'FEM-EV']
##METHODS=['VOF', 'DGBP', 'FEM-EV']
##dir_METHODS=['DGBP', 'FEM-EV']
##METHODS=['DGBP', 'FEM-EV']
##dir_METHODS=['VOF']
##METHODS=['VOF']
#dir_METHODS=['PARTICLES']
#METHODS=['Particles']
#  
##BOUYANCY_factors=['0.0', '0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9']
#BOUYANCY_factors=['0.0', '0.1', '0.2']
#FILENAME_BOUYANCY_factors=['0e0', '1e-1', '2e-1']
##BOUYANCY_factors=['0.4', '0.5', '0.6', '0.7', '0.8', '0.9']
##FILENAME_BOUYANCY_factors=['4e-1', '5e-1', '6e-1', '7e-1', '8e-1', '9e-1']
#
#TOP_LEVEL=os.getcwd() 
#for dsf in dir_DSF:
#  for index, method in enumerate(dir_METHODS):
#    for index_B, B in enumerate(BOUYANCY_factors):
#      path=dsf +'/' + method + '/' + METHODS[index] + '_Ra_1e5_B_' + B
#      data=path+'/solution/'
#      data_file = data + os.listdir(data)[1] 
#      if (os.path.exists(data_file)):
#        reader_sol = read_file(data_file)
#        Show(reader_sol)
#        Render()
#        view1 = GetActiveView()
#        set_dimensions(view1)
#        dp_sol = view1.GetPropertyValue('Representations')[0]
#        print(data_file)
#        set_solution_composition(reader_sol, dp_sol)
#        Render()
#        output_image_name = 'COMPOSITION_' + method + '_Ra_1e5_B_' + FILENAME_BOUYANCY_factors[index_B] + '_Time_' + '2.54e9' + '.png'
##        output_image_name = 'COMPOSITION_' + method + '_Ra_1e5_B_' + FILENAME_BOUYANCY_factors[index_B] + '_Time_' + '9.507e9' + '.png'
#        paraview.simple.SaveScreenshot(filename=output_image_name, viewOrLayout=view1, ImageQuality=100)
##        Delete(calc)
#        Delete(reader_sol)
  
#test_case = viz_data[0]
#reader_sol = read_file(test_case)

#test_case = 'DGBP_Ra_1e5_k_3_B_0.0/solution.pvd'
#reader_sol = read_file(test_case)
#
##print(compute_dim_time(np.array([0.02])))
#time = compute_dim_time(np.array([0.02]))
#time_values = find_approximate_data_file(reader_sol, time, True)
#
#Show(reader_sol)
#Render()
#view1 = GetActiveView()
#set_dimensions(view1)
#dp_sol = view1.GetPropertyValue('Representations')[0]
#set_solution_temperature(reader_sol, dp_sol)
#Hide(reader_sol)
#calc = Calculator()
#calc.SetPropertyWithName('ResultArrayName', 'Temperature')
#calc.SetPropertyWithName('Function', 'T/1500')
#Show(calc)
#Render()
#paraview.simple.SaveScreenshot(filename='test.png', viewOrLayout=view1, ImageQuality=100)

