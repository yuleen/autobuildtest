
#include "mainwindow.h"
#include "ui_mainwindow.h"

#include "version.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    ui->appVersionLabel->setText(QString("App version=%1").arg(APP_VERSION_STRING));
    ui->buildNoLabel->setText(QString("Build no=%1").arg(APP_BUILD_NO));
    ui->commitHashLabel->setText(QString("Commit hash=%1").arg(APP_COMMIT_HASH));
}

MainWindow::~MainWindow()
{
    delete ui;
}
