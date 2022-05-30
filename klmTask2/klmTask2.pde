import controlP5.*;

//ウィンドウサイズ
final int windowSizeX = 340;
final int windowSizeY = 550;

ControlP5 cp5;

int count, missCount;
final int taskNum = 10;   // タスク回数
float startTime, elapsedTime, tmp;
float[] lapTime = new float[taskNum];
boolean running = false;

final int max = 200;
final int min = -50;

PFont font, labelFont;

int whichConvert;   // 0：摂氏->華氏, 1：華氏->摂氏
int taskTemperature;
String taskText = "ここにタスクが表示される";
Textlabel taskLabel, minCentigradeLabel, maxCentigradeLabel, maxFahrenheitLabel, minFahrenheitLabel;
Slider centigradeSlider, fahrenheitSlider;
Button startButton, convertButton;


void settings(){
  size(windowSizeX,windowSizeY);
}

void setup(){
  font = createFont("osaka", 18, true);
  labelFont = createFont("osaka", 14, true);

  cp5 = new ControlP5(this);
  frameRate(100);

  fill(0);

  taskLabel = cp5.addTextlabel("task")
    .setPosition(90, 35)
    .setColor(color(0))
    .setFont(font)
    .setText(taskText);

  centigradeSlider = cp5.addSlider("摂氏")
    .setPosition(60, 110)
    .setSize(30, 400)
    .setRange(min, max)
    .setValue(25)
    .setNumberOfTickMarks(max - min + 1)  // 1目盛りの値を1.0にする
    .showTickMarks(false)
    .setColorLabel(color(0))
    .setFont(labelFont);
  centigradeSlider.getCaptionLabel()
    .setFont(font)
    .setPaddingX(-3)
    .setPaddingY(-430);

  fahrenheitSlider = cp5.addSlider("華氏")
    .setPosition(250, 110)
    .setSize(30, 400)
    .setRange(min, max)
    .setValue(25)
    .setNumberOfTickMarks(max - min + 1)  // 1目盛りの値を1.0にする
    .showTickMarks(false)
    .setColorLabel(color(0))
    .setFont(labelFont);
  fahrenheitSlider.getCaptionLabel()
    .setFont(font)
    .setPaddingX(-3)
    .setPaddingY(-430);
  fahrenheitSlider.getValueLabel()
    .setPaddingX(-75);

  maxCentigradeLabel = cp5.addTextlabel("maxCentigrade")
    .setPosition(20, 100)
    .setFont(labelFont)
    .setText(str(max));

  minCentigradeLabel = cp5.addTextlabel("minCentigrade")
    .setPosition(20, 500)
    .setFont(labelFont)
    .setText(str(min));

  maxFahrenheitLabel = cp5.addTextlabel("maxFahrenheit")
    .setPosition(285, 100)
    .setFont(labelFont)
    .setText(str(max));

  minFahrenheitLabel = cp5.addTextlabel("minFahrenheit")
    .setPosition(285, 500)
    .setFont(labelFont)
    .setText(str(min));

  startButton = cp5.addButton("startExp")
    .setLabel("start")
    .setFont(labelFont)
    .setPosition(290, 0)
    .setSize(50, 30);

  convertButton = cp5.addButton("convert")
    .setPosition(135, 300)
    .setSize(70, 30)
    .setFont(labelFont);
}

void draw () {
  smooth();
  background(150, 0.5);
  if(running) {
    if(count == taskNum) {
      println("----------------------");
      println("total time: " + elapsedTime + " ms");
      println("miss: " + missCount + " time");
      println("lap time:");
      for (int i = 0; i < taskNum; i++) {
        println(lapTime[i]);
      }
      exit();
    }
  }
}

public void startExp() {
  startTime = millis();
  tmp = 0.0;
  count = 0;
  missCount = 0;
  running = true;
  nextTask();
}

public void convert() {
  if(running) {
    float input = checkInput();
    if(input == taskTemperature) {
      tmp = elapsedTime;
      elapsedTime = millis() - startTime;
      lapTime[count] = elapsedTime - tmp;
      println("task " + (count+1) + ": " + lapTime[count] + " ms");
      count++;
      if(count < 10) nextTask();

    } else {
      taskLabel.setText(taskText + " X");
      println("miss");
      missCount++;
    }
  }
}

public void nextTask() {
  whichConvert = round(random(1));
  taskTemperature = round(random(93));  // 摂氏93度のとき華氏199度でギリギリスライダの最大値を超えない...
  if(whichConvert == 0) {
    taskText = "摂氏" + taskTemperature + "度を華氏に";
    taskLabel.setText(taskText);
  } else {
    taskText = "華氏" + taskTemperature + "度を摂氏に";
    taskLabel.setText(taskText);
  }
}

private int checkInput() {
  int input, output;
  if(whichConvert == 0) {
    // 摂氏->華氏
    input = (int)centigradeSlider.getValue();
    output = (int)((float)input * 1.8 + 32.0);
    fahrenheitSlider.setValue(output);
  } else {
    // 華氏->摂氏
    input = (int)fahrenheitSlider.getValue();
    output = (int)(((float)input - 32) / 1.8);
    centigradeSlider.setValue(output);
  }
  return input;
}
