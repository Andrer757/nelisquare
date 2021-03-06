#include <QtGui/QApplication>
#include <QtDeclarative>
#include <QDeclarativeContext>
#include <QDeclarativeEngine>
#include <QGraphicsObject>
#include <QInputContext>
#include <QSplashScreen>
#include "qmlapplicationviewer.h"
#include "picturehelper.h"
#include "windowhelper.h"
#include "cache.h"
#include "molome.h"

#include <qplatformdefs.h>

#if defined(Q_OS_HARMATTAN) || defined(Q_WS_SIMULATOR) || defined(Q_OS_MAEMO)
#include "platform_utils.h"
#endif

#if defined(Q_OS_HARMATTAN) || defined(Q_OS_MAEMO)
#include "nelisquare_dbus.h"
#endif

#if defined(Q_OS_HARMATTAN)
#include <MDeclarativeCache>
#endif

class EventDisabler : public QObject
{
protected:
    bool eventFilter(QObject *, QEvent *) {
        return true;
    }
private:
    QWidget *prevFocusWidget;
};

class EventFilter : public QObject
{
protected:
    bool eventFilter(QObject *obj, QEvent *event) {
        QInputContext *ic = qApp->inputContext();
        if (ic) {
            if (ic->focusWidget() == 0 && prevFocusWidget) {
                QEvent closeSIPEvent(QEvent::CloseSoftwareInputPanel);
                ic->filterEvent(&closeSIPEvent);
            } else if (prevFocusWidget == 0 && ic->focusWidget()) {
                QEvent openSIPEvent(QEvent::RequestSoftwareInputPanel);
                ic->filterEvent(&openSIPEvent);
            }
            prevFocusWidget = ic->focusWidget();
        }
        return QObject::eventFilter(obj,event);
    }

private:
    QWidget *prevFocusWidget;
};

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QApplication *app = createApplication(argc, argv);
    QmlApplicationViewer viewer;

#if defined(Q_OS_MAEMO)
    QPixmap pixmap("/opt/nelisquare/qml/pics/splash-turned.png");
    QSplashScreen splash(pixmap);
    EventDisabler eventDisabler;
    splash.installEventFilter(&eventDisabler);
    splash.showFullScreen();
#endif

#if defined(Q_OS_MAEMO)
    viewer.addImportPath(QString("/opt/qtm12/imports"));
    viewer.engine()->addImportPath(QString("/opt/qtm12/imports"));
    viewer.engine()->addPluginPath(QString("/opt/qtm12/plugins"));
#endif

    QCoreApplication::addLibraryPath(QString("/opt/nelisquare/plugins"));

    viewer.setAttribute(Qt::WA_OpaquePaintEvent);
    viewer.setAttribute(Qt::WA_NoSystemBackground);
    viewer.viewport()->setAttribute(Qt::WA_OpaquePaintEvent);
    viewer.viewport()->setAttribute(Qt::WA_NoSystemBackground);

    WindowHelper *windowHelper = new WindowHelper(&viewer);
    PictureHelper *pictureHelper = new PictureHelper();
    Cache *cache = new Cache();
    viewer.rootContext()->setContextProperty("windowHelper", windowHelper);
    viewer.rootContext()->setContextProperty("pictureHelper", pictureHelper);
    viewer.rootContext()->setContextProperty("cache", cache);

    Molome *molome = new Molome();
    viewer.rootContext()->setContextProperty("molome", molome);

#if defined(Q_OS_HARMATTAN) || defined(Q_WS_SIMULATOR) || defined(Q_OS_MAEMO)
    PlatformUtils platformUtils(app,cache);
    viewer.rootContext()->setContextProperty("platformUtils", &platformUtils);
#endif

#if defined(Q_OS_MAEMO)
    viewer.installEventFilter(windowHelper);
#elif defined(Q_OS_HARMATTAN)
    viewer.installEventFilter(new EventFilter);
#endif

    viewer.setMainQmlFile(QLatin1String("qml/main.qml"));

    QObject *rootObject = qobject_cast<QObject*>(viewer.rootObject());
#if defined(Q_OS_HARMATTAN) || defined(Q_OS_MAEMO)
    new NelisquareDbus(app, &viewer);
#endif

#if defined(Q_OS_MAEMO)
    viewer.showFullScreen();
#elif defined(Q_OS_HARMATTAN)
    rootObject->connect(molome,SIGNAL(infoUpdated(QVariant,QVariant)),SLOT(onMolomeInfoUpdate(QVariant,QVariant)));
    rootObject->connect(molome,SIGNAL(photoRecieved(QVariant,QVariant)),SLOT(onMolomePhoto(QVariant,QVariant)));
    viewer.showExpanded();
    molome->updateinfo();
#else
    viewer.showExpanded();
#endif
    rootObject->connect(pictureHelper,SIGNAL(pictureUploaded(QVariant, QVariant)),SLOT(onPictureUploaded(QVariant, QVariant)));

#if defined(Q_OS_MAEMO)
    splash.finish(&viewer);
#endif

    return app->exec();
}
