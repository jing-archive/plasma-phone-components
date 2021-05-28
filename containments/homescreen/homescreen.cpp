/***************************************************************************
 *   Copyright (C) 2015 Marco Martin <mart@kde.org>                        *
 *   Copyright (C) 2021 Wang Rui <wangrui@jingos.com>                      *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/

#include "homescreen.h"
#include "listmodelmanager.h"
#include "wallpapermanager.h"

#include <QtQml>
#include <QDebug>
#include <QQuickItem>

HomeScreen::HomeScreen(QObject *parent, const QVariantList &args)
    : Plasma::Containment(parent, args)
{
    qmlRegisterUncreatableType<ListModelManager>("org.kde.phone.homescreen", 1, 0, "ListModelManager", QStringLiteral("Cannot create item of type ApplicationListModel"));
    WallpaperManager::instance();

    setHasConfigurationInterface(true);
}

HomeScreen::~HomeScreen() = default;

void HomeScreen::configChanged()
{
    // Plasma::Containment::configChanged();
    // if (m_listModelManager) {
    //     m_listModelManager->loadSettings();
    // }
}

ListModelManager *HomeScreen::listModelManager()
{
    if (!m_listModelManager) {
        m_listModelManager = new ListModelManager(this);
    }
    return m_listModelManager;
}

void HomeScreen::stackBefore(QQuickItem *item1, QQuickItem *item2)
{
    if (!item1 || !item2 || item1 == item2 || item1->parentItem() != item2->parentItem()) {
        return;
    }

    item1->stackBefore(item2);
}

void HomeScreen::stackAfter(QQuickItem *item1, QQuickItem *item2)
{
    if (!item1 || !item2 || item1 == item2 || item1->parentItem() != item2->parentItem()) {
        return;
    }

    item1->stackAfter(item2);
}

K_EXPORT_PLASMA_APPLET_WITH_JSON(homescreen, HomeScreen, "metadata.json")

#include "homescreen.moc"
